# ==============================================================================
# Input Variables for Apigee X (Evaluation) Deployment
# ==============================================================================

# ------------------------------------------------------------------------------
# Project Creation & Identification
# ------------------------------------------------------------------------------

variable "create_project" {
  description = "Whether to create a new GCP project. If false, an existing project identified by var.project_id is used."
  type        = bool
  default     = false
}

variable "project_id" {
  description = "GCP Project ID. Must be globally unique if create_project = true, or specify the existing project ID."
  type        = string
}

variable "project_name" {
  description = "Display name of the GCP project when create_project = true."
  type        = string
  default     = "Hotel Events Dev"
}

variable "org_id" {
  description = "The numeric Google Cloud Organization ID (optional, mutually exclusive with folder_id). Used when create_project = true."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The numeric Google Cloud Folder ID (optional, mutually exclusive with org_id). Used when create_project = true."
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The alphanumeric Google Cloud Billing Account ID (e.g. 012345-6789AB-CDEF01). Required when create_project = true."
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# Region & Networking Configuration
# ------------------------------------------------------------------------------

variable "region" {
  description = "Google Cloud region for regional resources (subnets, Apigee instance, PSC NEG)."
  type        = string
  default     = "us-central1"
}

variable "apigee_analytics_region" {
  description = "Google Cloud analytics region for Apigee organization."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Name of the dedicated VPC network for Apigee."
  type        = string
  default     = "apigee-vpc"
}

variable "subnet_name" {
  description = "Name of the Apigee consumer subnetwork."
  type        = string
  default     = "apigee-subnet"
}

variable "subnet_cidr_range" {
  description = "Primary IP CIDR range for the Apigee consumer subnetwork."
  type        = string
  default     = "10.100.0.0/24"
}

variable "proxy_subnet_name" {
  description = "Name of the regional proxy-only subnetwork for Envoy Application Load Balancer."
  type        = string
  default     = "apigee-proxy-only-subnet"
}

variable "proxy_subnet_cidr_range" {
  description = "IP CIDR range for the proxy-only subnetwork (purpose = REGIONAL_MANAGED_PROXY)."
  type        = string
  default     = "10.100.1.0/24"
}

variable "peering_cidr_range" {
  description = "CIDR range allocated to Private Service Access (PSA) peering for Apigee runtime. Must be a /22 range (e.g. 10.0.0.0/22)."
  type        = string
  default     = "10.0.0.0/22"

  validation {
    condition     = can(regex("/22$", var.peering_cidr_range))
    error_message = "The peering_cidr_range must be a /22 CIDR block (e.g., 10.0.0.0/22) as required by Apigee X."
  }
}

# ------------------------------------------------------------------------------
# Apigee X Core Model
# ------------------------------------------------------------------------------

variable "apigee_instance_name" {
  description = "Name of the Apigee runtime instance."
  type        = string
  default     = "hotel-events-dev-instance"
}

variable "apigee_instance_description" {
  description = "Description for the Apigee runtime instance."
  type        = string
  default     = "Development Apigee X instance for Hotel Events platform"
}

variable "apigee_env_name" {
  description = "Name of the Apigee environment."
  type        = string
  default     = "dev"
}

variable "apigee_envgroup_name" {
  description = "Name of the Apigee environment group."
  type        = string
  default     = "dev-env-group"
}

variable "apigee_envgroup_hostnames" {
  description = "List of hostnames bound to the Apigee environment group for routing incoming requests."
  type        = list(string)
  default     = ["events-dev.example.com"]
}

# ------------------------------------------------------------------------------
# Optional Proxy Deployment Automation
# ------------------------------------------------------------------------------

variable "deploy_sample_proxy" {
  description = "Whether to automatically deploy the mock-hotel-events API proxy to the dev environment via local-exec."
  type        = bool
  default     = false
}
