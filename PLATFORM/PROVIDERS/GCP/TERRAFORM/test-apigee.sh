#!/usr/bin/env bash
# ==============================================================================
# test-apigee.sh
# Smoke test script for Apigee X ingress via Google Cloud Application Load Balancer.
#
# Verifies:
#   1. Load Balancer connectivity to Apigee PSC Network Endpoint Group (NEG).
#   2. Virtual host routing via environment group hostname Host header.
#   3. Confirms a 200 OK HTTP response from Apigee runtime.
#
# Usage:
#   ./test-apigee.sh [OPTIONS]
#
# Options:
#   -i, --ip <IP>          External Load Balancer IP address (auto-detected if omitted)
#   -h, --host <HOSTNAME>  Apigee envgroup hostname (auto-detected if omitted)
#   -p, --path <PATH>      Request path (default: /v1/healthz)
#   -s, --scheme <SCHEME>  http or https (default: http)
#   -r, --retries <NUM>    Number of retries to wait for route sync (default: 12)
#   -d, --delay <SECONDS>  Delay in seconds between retries (default: 10)
#   --all                  Test both HTTP (port 80) and HTTPS (port 443)
#   --help                 Display this help message
# ==============================================================================

set -euo pipefail

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

IP=""
HOST=""
PATH_SUFFIX="/v1/healthz"
SCHEME="http"
RETRIES=12
DELAY=10
TEST_ALL=false

# Print usage
show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Tests Apigee X Ingress via the Google Cloud Application Load Balancer.

Options:
  -i, --ip <IP>          Load Balancer external IP (auto-detected from terraform output)
  -h, --host <HOSTNAME>  Apigee Envgroup Hostname (auto-detected from terraform output)
  -p, --path <PATH>      Endpoint path (default: /v1/healthz)
  -s, --scheme <SCHEME>  Protocol scheme: http or https (default: http)
  -r, --retries <NUM>    Max retry attempts for warm-up (default: 12)
  -d, --delay <SECONDS>  Delay in seconds between retries (default: 10)
  --all                  Test both HTTP and HTTPS endpoints
  --help                 Show this help message
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--ip)
      IP="$2"
      shift 2
      ;;
    -h|--host)
      HOST="$2"
      shift 2
      ;;
    -p|--path)
      PATH_SUFFIX="$2"
      shift 2
      ;;
    -s|--scheme)
      SCHEME="$2"
      shift 2
      ;;
    -r|--retries)
      RETRIES="$2"
      shift 2
      ;;
    -d|--delay)
      DELAY="$2"
      shift 2
      ;;
    --all)
      TEST_ALL=true
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      show_help
      exit 1
      ;;
  esac
done

# Auto-detect IP from Terraform if not provided
if [[ -z "${IP}" ]]; then
  if command -v terraform &>/dev/null && [[ -f "main.tf" ]]; then
    echo -e "${BLUE}==> Auto-detecting load_balancer_ip from terraform outputs...${NC}"
    IP="$(terraform output -raw load_balancer_ip 2>/dev/null || true)"
  fi
fi

# Auto-detect Hostname from Terraform if not provided
if [[ -z "${HOST}" ]]; then
  if command -v terraform &>/dev/null && [[ -f "main.tf" ]]; then
    echo -e "${BLUE}==> Auto-detecting envgroup hostname from terraform outputs...${NC}"
    DETECTED_HOSTS="$(terraform output -json apigee_envgroup_hostnames 2>/dev/null || true)"
    if [[ -n "${DETECTED_HOSTS}" && "${DETECTED_HOSTS}" != "null" ]]; then
      HOST="$(echo "${DETECTED_HOSTS}" | grep -o '"[^"]*"' | head -n 1 | tr -d '"' || true)"
    fi
  fi
fi

# Fallback default hostname if detection failed
if [[ -z "${HOST}" ]]; then
  HOST="events-dev.example.com"
fi

if [[ -z "${IP}" ]]; then
  echo -e "${RED}Error: Load Balancer IP could not be resolved.${NC}"
  echo "Please supply --ip <IP_ADDRESS> or run from the directory with Terraform outputs."
  exit 1
fi

test_single_endpoint() {
  local TARGET_SCHEME="$1"
  local TARGET_URL="${TARGET_SCHEME}://${IP}${PATH_SUFFIX}"
  local EXTRA_CURL_FLAGS=()

  if [[ "${TARGET_SCHEME}" == "https" ]]; then
    # In dev, the HTTPS certificate is self-signed
    EXTRA_CURL_FLAGS+=("-k")
  fi

  echo ""
  echo -e "${BOLD}==============================================================================${NC}"
  echo -e "${BOLD}Testing Endpoint: ${TARGET_URL}${NC}"
  echo -e "Host Header      : ${HOST}"
  echo -e "Target Path      : ${PATH_SUFFIX}"
  echo -e "Protocol         : ${TARGET_SCHEME^^}"
  echo -e "${BOLD}==============================================================================${NC}"

  local SUCCESS=false
  local ATTEMPT=1
  local TEMP_HEADERS
  local TEMP_BODY
  TEMP_HEADERS="$(mktemp)"
  TEMP_BODY="$(mktemp)"

  while [[ ${ATTEMPT} -le ${RETRIES} ]]; do
    echo -e "${BLUE}[Attempt ${ATTEMPT}/${RETRIES}] Sending curl request to ${IP}...${NC}"

    HTTP_CODE="$(curl -s -S "${EXTRA_CURL_FLAGS[@]}" \
      --connect-timeout 8 \
      --max-time 15 \
      -D "${TEMP_HEADERS}" \
      -o "${TEMP_BODY}" \
      -w "%{http_code}" \
      -H "Host: ${HOST}" \
      "${TARGET_URL}" || echo "000")"

    if [[ "${HTTP_CODE}" == "200" ]]; then
      echo -e "${GREEN}${BOLD}✔ [PASS] Received HTTP 200 OK!${NC}"
      echo ""
      echo -e "${BLUE}--- Response Headers ---${NC}"
      cat "${TEMP_HEADERS}"
      echo -e "${BLUE}--- Response Payload ---${NC}"
      cat "${TEMP_BODY}"
      echo ""
      SUCCESS=true
      break
    elif [[ "${HTTP_CODE}" == "404" ]]; then
      echo -e "${YELLOW}Status 404: Apigee proxy route not found yet or Host header mismatch.${NC}"
    elif [[ "${HTTP_CODE}" == "502" || "${HTTP_CODE}" == "503" ]]; then
      echo -e "${YELLOW}Status ${HTTP_CODE}: Apigee PSC NEG / Envoy proxy warming up and syncing routes.${NC}"
    elif [[ "${HTTP_CODE}" == "000" ]]; then
      echo -e "${YELLOW}Connection failed or timed out. Load Balancer forwarding rules initializing.${NC}"
    else
      echo -e "${YELLOW}Received HTTP status ${HTTP_CODE}.${NC}"
    fi

    if [[ ${ATTEMPT} -lt ${RETRIES} ]]; then
      echo -e "Waiting ${DELAY}s before retry..."
      sleep "${DELAY}"
    fi
    ATTEMPT=$((ATTEMPT + 1))
  done

  rm -f "${TEMP_HEADERS}" "${TEMP_BODY}"

  if [[ "${SUCCESS}" != "true" ]]; then
    echo -e "${RED}${BOLD}✘ [FAIL] Did not receive 200 OK after ${RETRIES} attempts.${NC}"
    echo -e "${YELLOW}Diagnostic Tips:${NC}"
    echo "  1. Check if the sample proxy is deployed: ./deploy-proxy.sh --org <PROJECT_ID> --env dev --bundle sample-proxy/mock-hotel-events.zip"
    echo "  2. Confirm Apigee instance attachment status in GCP Console."
    echo "  3. Verify the Host header '${HOST}' matches google_apigee_envgroup hostnames."
    return 1
  fi

  return 0
}

OVERALL_STATUS=0

if [[ "${TEST_ALL}" == "true" ]]; then
  test_single_endpoint "http" || OVERALL_STATUS=1
  test_single_endpoint "https" || OVERALL_STATUS=1
else
  test_single_endpoint "${SCHEME}" || OVERALL_STATUS=1
fi

echo ""
if [[ ${OVERALL_STATUS} -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}==============================================================================${NC}"
  echo -e "${GREEN}${BOLD}ALL APIGEE SMOKE TESTS PASSED SUCCESSFULLY!${NC}"
  echo -e "${GREEN}${BOLD}==============================================================================${NC}"
else
  echo -e "${RED}${BOLD}==============================================================================${NC}"
  echo -e "${RED}${BOLD}SOME APIGEE SMOKE TESTS FAILED.${NC}"
  echo -e "${RED}${BOLD}==============================================================================${NC}"
fi

exit ${OVERALL_STATUS}
