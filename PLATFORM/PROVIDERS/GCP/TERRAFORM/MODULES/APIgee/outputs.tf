output "apigee_organization_id" {
  description = "The ID of the Apigee organization."
  value       = google_apigee_organization.this.id
}

output "apigee_instance_name" {
  description = "The name of the Apigee runtime instance."
  value       = google_apigee_instance.this.name
}

output "apigee_environment_name" {
  description = "The name of the Apigee environment."
  value       = google_apigee_environment.this.name
}

output "apigee_envgroup_name" {
  description = "The name of the Apigee environment group."
  value       = google_apigee_envgroup.this.name
}

output "apigee_instance_service_attachment" {
  description = "The Private Service Connect (PSC) service attachment URI of the Apigee instance."
  value       = google_apigee_instance.this.service_attachment
}

