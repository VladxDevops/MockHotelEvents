compute_project_id = "hotel-events-dev-project"
region             = "us-central1"

apigee_analytics_region   = "us-central1"
apigee_authorized_network = "default"
apigee_runtime_type       = "CLOUD"
apigee_billing_type       = "EVALUATION"

apigee_organization_display_name = "Hotel Events Platform"
apigee_organization_description  = "Managed API exposure layer for the hotel events platform."

apigee_instance_name        = "hotel-events-dev-instance"
apigee_instance_location    = "us-central1"
apigee_instance_description = "Development Apigee runtime for the hotel events platform."
apigee_instance_cidr_range  = "10.0.0.0/22"

apigee_environment_name         = "DEV"
apigee_environment_display_name = "Development"
apigee_environment_description  = "Development environment for hotel event API proxies."

apigee_envgroup_name      = "hotel-events-dev"
apigee_envgroup_hostnames = ["events-dev.example.com"]
