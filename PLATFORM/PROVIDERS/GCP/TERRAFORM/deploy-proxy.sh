#!/usr/bin/env bash
# ==============================================================================
# deploy-proxy.sh
# Deploys an Apigee API proxy bundle to an Apigee X environment using the
# Apigee Management API.
#
# Usage:
#   ./deploy-proxy.sh \
#     --org <APIGEE_ORG> \
#     --env <APIGEE_ENV> \
#     --bundle <PATH_TO_ZIP> \
#     [--proxy-name <PROXY_NAME>]
# ==============================================================================

set -euo pipefail

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ORG=""
ENV="dev"
BUNDLE=""
PROXY_NAME="mock-hotel-events"
PROJECT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --org)
      ORG="$2"
      shift 2
      ;;
    --env)
      ENV="$2"
      shift 2
      ;;
    --bundle)
      BUNDLE="$2"
      shift 2
      ;;
    --proxy-name)
      PROXY_NAME="$2"
      shift 2
      ;;
    --project)
      PROJECT="$2"
      shift 2
      ;;
    *)
      echo -e "${RED}Unknown argument: $1${NC}"
      exit 1
      ;;
  esac
done

if [[ -z "${ORG}" ]]; then
  if [[ -n "${PROJECT}" ]]; then
    ORG="${PROJECT}"
  else
    echo -e "${RED}Error: --org (or --project) is required.${NC}"
    exit 1
  fi
fi

if [[ -z "${BUNDLE}" || ! -f "${BUNDLE}" ]]; then
  echo -e "${RED}Error: Proxy bundle file not found at: ${BUNDLE}${NC}"
  exit 1
fi

echo -e "${BLUE}==> Apigee Proxy Deployment: ${PROXY_NAME}${NC}"
echo "    Organization : ${ORG}"
echo "    Environment  : ${ENV}"
echo "    Bundle Path  : ${BUNDLE}"

# Acquire OAuth2 token
TOKEN="${GOOGLE_OAUTH_ACCESS_TOKEN:-}"
if [[ -z "${TOKEN}" ]]; then
  if command -v gcloud &>/dev/null; then
    TOKEN="$(timeout 5s gcloud auth print-access-token 2>/dev/null || true)"
  fi
fi

if [[ -z "${TOKEN}" ]]; then
  echo -e "${YELLOW}Warning: No Google OAuth access token available via environment or gcloud.${NC}"
  echo -e "${YELLOW}Skipping automatic API proxy deployment. You can deploy manually using:${NC}"
  echo "  gcloud auth print-access-token"
  echo "  curl -X POST -H 'Authorization: Bearer <TOKEN>' -H 'Content-Type: multipart/form-data' ..."
  exit 0
fi

echo -e "${BLUE}==> Importing proxy bundle into Apigee organization...${NC}"
IMPORT_RESPONSE="$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@${BUNDLE}" \
  "https://apigee.googleapis.com/v1/organizations/${ORG}/apis?name=${PROXY_NAME}&action=import")"

HTTP_STATUS="$(echo "${IMPORT_RESPONSE}" | tail -n 1)"
BODY="$(echo "${IMPORT_RESPONSE}" | sed '$d')"

if [[ "${HTTP_STATUS}" != "200" && "${HTTP_STATUS}" != "201" ]]; then
  echo -e "${RED}Failed to import API proxy. HTTP ${HTTP_STATUS}:${NC}"
  echo "${BODY}"
  exit 1
fi

REVISION="$(echo "${BODY}" | grep -o '"revision": "[^"]*' | head -n 1 | cut -d'"' -f4 || true)"
if [[ -z "${REVISION}" ]]; then
  REVISION="1"
fi

echo -e "${GREEN}==> Proxy imported successfully as revision ${REVISION}.${NC}"

echo -e "${BLUE}==> Deploying revision ${REVISION} to environment '${ENV}'...${NC}"
DEPLOY_RESPONSE="$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://apigee.googleapis.com/v1/organizations/${ORG}/environments/${ENV}/apis/${PROXY_NAME}/revisions/${REVISION}/deployments?override=true")"

DEPLOY_STATUS="$(echo "${DEPLOY_RESPONSE}" | tail -n 1)"
DEPLOY_BODY="$(echo "${DEPLOY_RESPONSE}" | sed '$d')"

if [[ "${DEPLOY_STATUS}" != "200" && "${DEPLOY_STATUS}" != "201" ]]; then
  echo -e "${RED}Failed to deploy API proxy. HTTP ${DEPLOY_STATUS}:${NC}"
  echo "${DEPLOY_BODY}"
  exit 1
fi

echo -e "${GREEN}==> Proxy '${PROXY_NAME}' revision ${REVISION} deployed successfully to '${ENV}'!${NC}"
