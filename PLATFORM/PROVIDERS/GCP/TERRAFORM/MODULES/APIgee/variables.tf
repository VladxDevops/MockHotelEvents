variable "compute_project_id" {
  description = "GCP compute project ID where Apigee is provisioned."
  type        = string
}

variable "region" {
  description = "Default Google Cloud region for the project and runtime resources."
  type        = string
}

variable "apigee_organization_display_name" {
  description = "Friendly display name for the Apigee organization."
  type        = string
  default     = "Hotel Events Platform"
}

variable "apigee_organization_description" {
  description = "Description for the Apigee organization."
  type        = string
  default     = "Managed API exposure layer for the hotel events platform."
}

variable "apigee_analytics_region" {
  description = "Google Cloud region used for Apigee analytics."
  type        = string
}

variable "apigee_authorized_network" {
  description = "The VPC network authorized for Apigee."
  type        = string
  default     = "default"
}

variable "apigee_runtime_type" {
  description = "Apigee runtime type. For most cloud-native deployments use CLOUD."
  type        = string
  default     = "CLOUD"
}

variable "apigee_billing_type" {
  description = "Apigee billing type. Use EVALUATION for dev/testing and SUBSCRIPTION for production."
  type        = string
  default     = "EVALUATION"
}

variable "apigee_instance_name" {
  description = "Name of the Apigee runtime instance."
  type        = string
}

variable "apigee_instance_location" {
  description = "Location for the Apigee instance."
  type        = string
}

variable "apigee_instance_description" {
  description = "Optional description for the Apigee instance."
  type        = string
  default     = "Apigee runtime for the hotel events platform."
}

variable "apigee_instance_cidr_range" {
  description = "CIDR block reserved for Apigee peering. Example: 10.0.0.0/22"
  type        = string
}

variable "apigee_environment_name" {
  description = "Name of the Apigee environment."
  type        = string
}

variable "apigee_environment_display_name" {
  description = "Display name for the Apigee environment."
  type        = string
}

variable "apigee_environment_description" {
  description = "Description for the Apigee environment."
  type        = string
  default     = "Development environment for hotel event API proxies."
}

variable "apigee_envgroup_name" {
  description = "Name of the Apigee environment group."
  type        = string
}

variable "apigee_envgroup_hostnames" {
  description = "Hostnames associated with the Apigee environment group."
  type        = list(string)
  default     = []
}
