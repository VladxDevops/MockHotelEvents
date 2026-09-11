You are an expert Google Cloud Infrastructure and Terraform engineer.

TASK OVERVIEW:
Create a complete, clean, MVP-ready Terraform codebase for provisioning an Apigee X (Evaluation) setup on GCP from scratch. The code must be designed assuming this is the FIRST time deploying to a brand new GCP project that DOES NOT EXIST YET (or needs to be created dynamically by Terraform).

PREREQUISITE CHECK:
1. Search and inspect `Agents.md` in the root/main directory to understand project context, guidelines, and naming conventions.
2. Check for any existing Terraform files or Apigee Terraform modules in the workspace.
3. Perform a security review: Verify no API keys, service account JSON files, or secrets are hardcoded or tracked in git history. Ensure `.gitignore` ignores `*.tfvars`, `*.tfstate`, and `.terraform/`.

REQUIREMENTS & ARCHITECTURE:
1. Project Creation & Initial Setup:
   - Include resource block for `google_project` (or allow passing an existing `project_id` via a variable boolean `create_project`).
   - Enable necessary service APIs (`google_project_service`) with `disable_on_destroy = false`:
     * `apigee.googleapis.com`
     * `compute.googleapis.com`
     * `servicenetworking.googleapis.com`
     * `cloudresourcemanager.googleapis.com`

2. Core Infrastructure & Apigee X Model:
   - Apigee X Evaluation Organization (`google_apigee_organization` with `billing_type = "EVALUATION"` and no KMS/CMEK requirement).
   - Dedicated VPC (`apigee-vpc`) and Subnet (`apigee-subnet`).
   - Proxy-only subnet (`purpose = "REGIONAL_MANAGED_PROXY"`) required for Global External Application Load Balancer.
   - Private Service Access (PSA) range allocation (`google_compute_global_address`) and Service Networking connection (`google_service_networking_connection`).
   - Apigee Instance + Environment (`dev`) + Environment Group (`dev-env-group`).
   - Ingress Routing: Global External Application Load Balancer connected to Apigee using a Private Service Connect (PSC) Network Endpoint Group (`google_compute_region_network_endpoint_group` of type `PRIVATE_SERVICE_CONNECT`).

3. File Structure to Generate:
   - `main.tf`: GCP Project creation, Provider setup, API enablement, VPC network, PSA peering, Apigee Organization/Instance/Env, PSC NEG, L7 Load Balancer, and sample `google_apigee_proxy_deployment`.
   - `variables.tf`: Declare project variables (`project_id`, `org_id` / `folder_id` for project creation, `billing_account`, `region`, `peering_cidr_range`, `apigee_env_name`).
   - `dev.tfvars`: Sample variables pre-populated with default dev values and placeholders for project/billing info.
   - `outputs.tf`: Export `project_id`, `apigee_org_id`, `load_balancer_ip`, and `apigee_instance_service_attachment`.
   - `test-apigee.sh`: Bash script using curl to test the endpoint via the Load Balancer IP and confirm a `200 OK` response.

4. Coding Practices & Timings:
   - Keep HCL straightforward, highly readable, and well-commented.
   - Apigee API enablement and Organization creation take time: Use explicit `depends_on` blocks and `time_sleep` resources where appropriate to prevent API race conditions during initial deployment on a brand new GCP project.

Execute this setup step-by-step. Begin by reviewing `Agents.md` and existing workspace security.