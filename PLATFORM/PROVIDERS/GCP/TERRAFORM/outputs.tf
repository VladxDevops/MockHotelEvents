# ==============================================================================
# Terraform Outputs for Apigee X Infrastructure
# ==============================================================================

output "project_id" {
  description = "The GCP Project ID where Apigee resources are provisioned."
  value       = local.project_id
}

output "apigee_org_id" {
  description = "The ID of the Apigee organization."
  value       = google_apigee_organization.apigee_org.id
}

output "load_balancer_ip" {
  description = "The static external IPv4 address of the Application Load Balancer."
  value       = google_compute_global_address.apigee_lb_ip.address
}

output "apigee_instance_service_attachment" {
  description = "The Private Service Connect (PSC) service attachment URI of the Apigee instance."
  value       = google_apigee_instance.apigee_instance.service_attachment
}

# ------------------------------------------------------------------------------
# Additional Contextual & Testing Outputs
# ------------------------------------------------------------------------------

output "apigee_instance_name" {
  description = "The name of the Apigee runtime instance."
  value       = google_apigee_instance.apigee_instance.name
}

output "apigee_environment_name" {
  description = "The name of the Apigee environment."
  value       = google_apigee_environment.apigee_env.name
}

output "apigee_envgroup_name" {
  description = "The name of the Apigee environment group."
  value       = google_apigee_envgroup.apigee_envgroup.name
}

output "apigee_envgroup_hostnames" {
  description = "The list of hostnames mapped in the Apigee environment group."
  value       = google_apigee_envgroup.apigee_envgroup.hostnames
}

output "test_curl_command_http" {
  description = "Ready-to-use curl command to test Apigee via the Load Balancer HTTP frontend."
  value       = "curl -i -H 'Host: ${var.apigee_envgroup_hostnames[0]}' http://${google_compute_global_address.apigee_lb_ip.address}/v1/healthz"
}

output "test_curl_command_https" {
  description = "Ready-to-use curl command to test Apigee via the Load Balancer HTTPS frontend."
  value       = "curl -i -k -H 'Host: ${var.apigee_envgroup_hostnames[0]}' https://${google_compute_global_address.apigee_lb_ip.address}/v1/healthz"
}
