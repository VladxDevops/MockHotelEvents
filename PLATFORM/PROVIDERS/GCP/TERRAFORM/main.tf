# ==============================================================================
# Apigee X (Evaluation) Complete Infrastructure Setup on Google Cloud Platform
# ==============================================================================
# Architecture Overview:
# 1. Project Creation & API Enablement (Apigee, Compute, Service Networking, CRM)
# 2. Dedicated VPC Network & Subnets (including Regional Proxy-Only Subnet for ALB)
# 3. Private Service Access (PSA) Peering for Apigee Managed Runtime
# 4. Apigee X Evaluation Organization, Runtime Instance, Environment & Env Group
# 5. Northbound Ingress: External Application Load Balancer with PSC NEG
# 6. Sample API Proxy Bundle Packaging & Automated Deployment Hook
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Project Creation & Identification
# ------------------------------------------------------------------------------

# Conditionally provision a brand-new GCP project if create_project = true.
# If create_project = false, the existing project identified by var.project_id is used.
resource "google_project" "project" {
  count               = var.create_project ? 1 : 0
  name                = var.project_name
  project_id          = var.project_id
  org_id              = var.org_id != "" ? var.org_id : null
  folder_id           = var.folder_id != "" ? var.folder_id : null
  billing_account     = var.billing_account != "" ? var.billing_account : null
  auto_create_network = false
}

locals {
  project_id = var.create_project ? google_project.project[0].project_id : var.project_id

  required_services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "apigee.googleapis.com"
  ]
}

# ------------------------------------------------------------------------------
# 2. Service API Enablement
# ------------------------------------------------------------------------------

# Enable all required GCP service APIs with disable_on_destroy = false to protect resources
resource "google_project_service" "apis" {
  for_each                   = toset(local.required_services)
  project                    = local.project_id
  service                    = each.key
  disable_on_destroy         = false
  disable_dependent_services = false

  depends_on = [google_project.project]
}

# Wait for API activation to propagate across GCP control planes before provisioning networks
resource "time_sleep" "wait_for_services" {
  depends_on      = [google_project_service.apis]
  create_duration = "60s"
}

# ------------------------------------------------------------------------------
# 3. Dedicated VPC Network & Subnets
# ------------------------------------------------------------------------------

# Custom VPC network dedicated to Apigee ingress and egress
resource "google_compute_network" "apigee_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = local.project_id

  depends_on = [time_sleep.wait_for_services]
}

# Consumer subnetwork in the target region for PSC NEGs and local compute resources
resource "google_compute_subnetwork" "apigee_subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cidr_range
  region                   = var.region
  network                  = google_compute_network.apigee_vpc.id
  private_ip_google_access = true
  project                  = local.project_id
}

# Regional Proxy-Only Subnet required by Envoy-based Application Load Balancers
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = var.proxy_subnet_name
  ip_cidr_range = var.proxy_subnet_cidr_range
  region        = var.region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.apigee_vpc.id
  project       = local.project_id
}

# Firewall rule allowing Google Load Balancer health checks and proxies into the VPC
resource "google_compute_firewall" "allow_lb_and_health_checks" {
  name    = "allow-lb-and-health-checks"
  network = google_compute_network.apigee_vpc.id
  project = local.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Standard Google Cloud Load Balancer & Health Check probe source ranges
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# ------------------------------------------------------------------------------
# 4. Private Service Access (PSA) Peering
# ------------------------------------------------------------------------------

# Reserve an internal IP address range for Service Networking peering
resource "google_compute_global_address" "apigee_psa_range" {
  name          = "apigee-psa-peering-range"
  description   = "Reserved IP range for Apigee Private Service Access peering"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = split("/", var.peering_cidr_range)[0]
  prefix_length = tonumber(split("/", var.peering_cidr_range)[1])
  network       = google_compute_network.apigee_vpc.id
  project       = local.project_id

  depends_on = [time_sleep.wait_for_services]
}

# Establish Private Services Access (PSA) peering connection with Google services network
resource "google_service_networking_connection" "apigee_psa_connection" {
  network                 = google_compute_network.apigee_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.apigee_psa_range.name]

  depends_on = [
    google_project_service.apis,
    google_compute_global_address.apigee_psa_range
  ]
}

# Allow peering route tables and control planes to settle before initiating Apigee org creation
resource "time_sleep" "wait_for_psa" {
  depends_on      = [google_service_networking_connection.apigee_psa_connection]
  create_duration = "30s"
}

# ------------------------------------------------------------------------------
# 5. Core Apigee X Evaluation Infrastructure
# ------------------------------------------------------------------------------

# Apigee X Organization in EVALUATION billing mode (does not require CMEK encryption keys)
resource "google_apigee_organization" "apigee_org" {
  project_id         = local.project_id
  display_name       = "Hotel Events Platform"
  description        = "Managed API exposure layer for Hotel Events planning platform"
  analytics_region   = var.apigee_analytics_region
  authorized_network = google_compute_network.apigee_vpc.id
  runtime_type       = "CLOUD"
  billing_type       = "EVALUATION"

  depends_on = [
    time_sleep.wait_for_psa,
    google_service_networking_connection.apigee_psa_connection
  ]
}

# Wait for Apigee Organization control plane initialization
resource "time_sleep" "wait_for_apigee_org" {
  depends_on      = [google_apigee_organization.apigee_org]
  create_duration = "30s"
}

# Apigee Runtime Instance provisioned in the target region
resource "google_apigee_instance" "apigee_instance" {
  name               = var.apigee_instance_name
  location           = var.region
  description        = var.apigee_instance_description
  org_id             = google_apigee_organization.apigee_org.id
  ip_range           = var.peering_cidr_range
  peering_cidr_range = "SLASH_22"

  depends_on = [time_sleep.wait_for_apigee_org]
}

# Apigee Environment ('dev')
resource "google_apigee_environment" "apigee_env" {
  org_id       = google_apigee_organization.apigee_org.id
  name         = var.apigee_env_name
  display_name = "Development"
  description  = "Development environment for hotel event API proxies"

  depends_on = [google_apigee_organization.apigee_org]
}

# Apigee Environment Group ('dev-env-group')
resource "google_apigee_envgroup" "apigee_envgroup" {
  org_id    = google_apigee_organization.apigee_org.id
  name      = var.apigee_envgroup_name
  hostnames = var.apigee_envgroup_hostnames

  depends_on = [google_apigee_organization.apigee_org]
}

# Attach Environment to Environment Group (routes hostname requests to dev environment)
resource "google_apigee_envgroup_attachment" "apigee_envgroup_attachment" {
  envgroup_id = google_apigee_envgroup.apigee_envgroup.id
  environment = google_apigee_environment.apigee_env.name
}

# Attach Environment to Instance (provisions runtime capacity for dev environment)
resource "google_apigee_instance_attachment" "apigee_instance_attachment" {
  instance_id = google_apigee_instance.apigee_instance.id
  environment = google_apigee_environment.apigee_env.name
}

# ------------------------------------------------------------------------------
# 6. Ingress Routing: Global External Application Load Balancer with PSC NEG
# ------------------------------------------------------------------------------

# Regional Network Endpoint Group of type PRIVATE_SERVICE_CONNECT pointing to Apigee
resource "google_compute_region_network_endpoint_group" "apigee_psc_neg" {
  name                  = "apigee-psc-neg"
  description           = "Private Service Connect NEG targeting Apigee instance service attachment"
  region                = var.region
  network               = google_compute_network.apigee_vpc.id
  subnetwork            = google_compute_subnetwork.apigee_subnet.id
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = google_apigee_instance.apigee_instance.service_attachment
  project               = local.project_id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_apigee_instance.apigee_instance]
}

# Static External IPv4 Address for the Load Balancer
resource "google_compute_global_address" "apigee_lb_ip" {
  name         = "apigee-lb-ip"
  description  = "Static public IP address for external Apigee Load Balancer"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
  project      = local.project_id

  depends_on = [time_sleep.wait_for_services]
}

# Global Backend Service referencing the Apigee PSC NEG
# Note: PSC NEGs do not support active health checks in Google Cloud
resource "google_compute_backend_service" "apigee_backend" {
  name                  = "apigee-backend-service"
  description           = "Backend service routing traffic to Apigee X PSC NEG"
  protocol              = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project               = local.project_id

  backend {
    group = google_compute_region_network_endpoint_group.apigee_psc_neg.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

# URL Map directing incoming requests to the Apigee backend service
resource "google_compute_url_map" "apigee_url_map" {
  name            = "apigee-url-map"
  description     = "Default URL map routing all requests to Apigee backend"
  default_service = google_compute_backend_service.apigee_backend.id
  project         = local.project_id
}

# Frontend 1: Target HTTP Proxy & Global Forwarding Rule (Port 80)
# Enables immediate curl verification without requiring DNS propagation or TLS certificates
resource "google_compute_target_http_proxy" "apigee_http_proxy" {
  name    = "apigee-http-proxy"
  url_map = google_compute_url_map.apigee_url_map.id
  project = local.project_id
}

resource "google_compute_global_forwarding_rule" "apigee_http_forwarding_rule" {
  name                  = "apigee-http-forwarding-rule"
  description           = "Global forwarding rule for HTTP port 80"
  target                = google_compute_target_http_proxy.apigee_http_proxy.id
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.apigee_lb_ip.address
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project               = local.project_id
}

# Frontend 2: Target HTTPS Proxy & Global Forwarding Rule (Port 443 with TLS cert)
# Generates a self-signed TLS cert for development/testing matching the envgroup hostname
resource "tls_private_key" "apigee_cert_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "apigee_self_signed_cert" {
  private_key_pem = tls_private_key.apigee_cert_key.private_key_pem

  subject {
    common_name  = var.apigee_envgroup_hostnames[0]
    organization = "Hotel Events Platform"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "google_compute_ssl_certificate" "apigee_ssl_cert" {
  name        = "apigee-self-signed-cert"
  description = "Self-signed SSL certificate for Apigee dev environment testing"
  private_key = tls_private_key.apigee_cert_key.private_key_pem
  certificate = tls_self_signed_cert.apigee_self_signed_cert.cert_pem
  project     = local.project_id
}

resource "google_compute_target_https_proxy" "apigee_https_proxy" {
  name             = "apigee-https-proxy"
  url_map          = google_compute_url_map.apigee_url_map.id
  ssl_certificates = [google_compute_ssl_certificate.apigee_ssl_cert.id]
  project          = local.project_id
}

resource "google_compute_global_forwarding_rule" "apigee_https_forwarding_rule" {
  name                  = "apigee-https-forwarding-rule"
  description           = "Global forwarding rule for HTTPS port 443"
  target                = google_compute_target_https_proxy.apigee_https_proxy.id
  port_range            = "443"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.apigee_lb_ip.address
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project               = local.project_id
}

# ------------------------------------------------------------------------------
# 7. Sample Apigee Proxy Bundle & Automated Deployment Hook
# ------------------------------------------------------------------------------
# In the official Google Cloud Terraform provider, proxy bundles (API proxies) are
# managed as API metadata rather than native infrastructure resources.
# Here we package the mock-hotel-events API proxy bundle into a ZIP archive and
# provide a deployment automation hook via local-exec to deploy to Apigee runtime.

data "archive_file" "sample_proxy_bundle" {
  type        = "zip"
  source_dir  = "${path.module}/sample-proxy/mock-hotel-events"
  output_path = "${path.module}/sample-proxy/mock-hotel-events.zip"
}

resource "null_resource" "sample_proxy_deployment" {
  count = var.deploy_sample_proxy ? 1 : 0

  triggers = {
    bundle_hash = data.archive_file.sample_proxy_bundle.output_base64sha256
    instance_id = google_apigee_instance_attachment.apigee_instance_attachment.id
    envgroup_id = google_apigee_envgroup_attachment.apigee_envgroup_attachment.id
  }

  provisioner "local-exec" {
    command = <<-EOT
      bash ${path.module}/deploy-proxy.sh \
        --project "${local.project_id}" \
        --org "${google_apigee_organization.apigee_org.name}" \
        --env "${google_apigee_environment.apigee_env.name}" \
        --bundle "${data.archive_file.sample_proxy_bundle.output_path}" \
        --proxy-name "mock-hotel-events"
    EOT
  }

  depends_on = [
    google_apigee_instance_attachment.apigee_instance_attachment,
    google_apigee_envgroup_attachment.apigee_envgroup_attachment
  ]
}
