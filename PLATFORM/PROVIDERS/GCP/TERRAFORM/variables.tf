# ==============================================================================
# Input Variables for Apigee X (Evaluation) Deployment
# ==============================================================================

# ------------------------------------------------------------------------------
# Project Creation & Identification
# ------------------------------------------------------------------------------



variable "compute_project_id" {
  description = "GCP compute project ID. Must be globally unique if create_project = true, or specify the existing project ID."
  type        = string
}

variable "compute_project_name" {
  description = "Display name of the GCP compute project when create_project = true."
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
# DEV Service Accounts, IAM, and Secrets
# ------------------------------------------------------------------------------

variable "dev_service_account_ids" {
  description = "List of runtime service account IDs used by the DEV environment. Kept explicit so the first deployment in a newly created project has a deterministic baseline."
  type        = list(string)
  default = [
    "hotel-events-dev-inquiry-sa",
    "hotel-events-dev-availability-sa",
    "hotel-events-dev-pricing-sa",
    "hotel-events-dev-booking-sa",
    "hotel-events-dev-operations-sa"
  ]
}

variable "inquiry_service_account_id" {
  description = "Service account ID for the inquiry workload in the DEV environment."
  type        = string
  default     = "he-dev-inquiry"
}

variable "availability_service_account_id" {
  description = "Service account ID for the availability workload in the DEV environment."
  type        = string
  default     = "he-dev-availability"
}

variable "pricing_service_account_id" {
  description = "Service account ID for the pricing workload in the DEV environment."
  type        = string
  default     = "he-dev-pricing"
}

variable "booking_service_account_id" {
  description = "Service account ID for the booking workload in the DEV environment."
  type        = string
  default     = "he-dev-booking"
}

variable "operations_service_account_id" {
  description = "Service account ID for the operations workload in the DEV environment."
  type        = string
  default     = "he-dev-operations"
}

variable "salesforce_api_key" {
  description = "Placeholder Salesforce API key for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_SALESFORCE_API_KEY"
  sensitive   = true
}

variable "salesforce_client_secret" {
  description = "Placeholder Salesforce client secret for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_SALESFORCE_CLIENT_SECRET"
  sensitive   = true
}

variable "mulesoft_client_id" {
  description = "Placeholder Mulesoft client ID for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_MULESOFT_CLIENT_ID"
  sensitive   = true
}

variable "mulesoft_client_secret" {
  description = "Placeholder Mulesoft client secret for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_MULESOFT_CLIENT_SECRET"
  sensitive   = true
}

variable "redis_password" {
  description = "Placeholder Redis password for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_REDIS_PASSWORD"
  sensitive   = true
}

variable "database_password" {
  description = "Placeholder database password for the DEV environment. Replace with a real secret before non-demo use."
  type        = string
  default     = "PLACEHOLDER_DATABASE_PASSWORD"
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Optional Proxy Deployment Automation
# ------------------------------------------------------------------------------

variable "deploy_sample_proxy" {
  description = "Whether to automatically deploy the mock-hotel-events API proxy to the dev environment via local-exec."
  type        = bool
  default     = false
}
