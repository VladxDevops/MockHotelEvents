terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.compute_project_id
  region  = var.region
}

# Lowest-hanging-fruit Apigee foundation for the hotel events platform.
# This covers the API management layer only. The proxy bundle itself is typically
# deployed separately via Apigee tooling or CI/CD rather than Terraform directly.
resource "google_apigee_organization" "this" {
  project_id         = var.compute_project_id
  analytics_region   = var.apigee_analytics_region
  authorized_network = var.apigee_authorized_network
  description        = var.apigee_organization_description
  display_name       = var.apigee_organization_display_name
  runtime_type       = var.apigee_runtime_type
  billing_type       = var.apigee_billing_type
}

resource "google_apigee_instance" "this" {
  org_id             = google_apigee_organization.this.id
  name               = var.apigee_instance_name
  location           = var.apigee_instance_location
  description        = var.apigee_instance_description
  peering_cidr_range = var.apigee_instance_cidr_range
}

resource "google_apigee_environment" "this" {
  org_id       = google_apigee_organization.this.id
  name         = var.apigee_environment_name
  display_name = var.apigee_environment_display_name
  description  = var.apigee_environment_description
}

resource "google_apigee_envgroup" "this" {
  org_id    = google_apigee_organization.this.id
  name      = var.apigee_envgroup_name
  hostnames = var.apigee_envgroup_hostnames
}

resource "google_apigee_envgroup_attachment" "this" {
  envgroup_id = google_apigee_envgroup.this.id
  environment = google_apigee_environment.this.name
}

resource "google_apigee_instance_attachment" "this" {
  instance_id = google_apigee_instance.this.id
  environment = google_apigee_environment.this.name
}

