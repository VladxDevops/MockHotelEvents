# Apigee X MVP Infrastructure Architecture (Public Ingress)

## Overview
This document outlines the Minimal Viable Product (MVP) architecture for deploying an evaluation-based **Apigee X** environment on Google Cloud Platform using Terraform. It features a fully private Apigee runtime exposed via a Global External Application Load Balancer using Private Service Connect (PSC).

## Architecture Layout

[ Public Client / Internet ]
                           │
                           ▼
    ┌──────────────────────────────────────────────┐
    │ Global External Application Load Balancer    │
    │ (Public IP + Managed TLS / Self-Signed Cert) │
    └──────────────────────┬───────────────────────┘
                           │
                           ▼
    ┌──────────────────────────────────────────────┐
    │  Customer VPC (Project: ${var.project_id})   │
    │                                              │
    │  ┌────────────────────────────────────────┐  │
    │  │ PSC Network Endpoint Group (NEG)       │  │
    │  └───────────────────┬────────────────────┘  │
    └──────────────────────┼───────────────────────┘
                           │ (Private Service Connect)
    ┌──────────────────────▼───────────────────────┐
    │     Apigee Tenant Project (Google-Managed)   │
    │  ┌────────────────────────────────────────┐  │
    │  │ Apigee Runtime Instance (EVAL)         │  │
    │  │ - Proxy Engine & Key Management        │  │
    │  └───────────────────┬────────────────────┘  │
    └──────────────────────┼───────────────────────┘
                           │ (Private Service Access / VPC Peering)
    ┌──────────────────────▼───────────────────────┐
    │ Customer VPC Subnet                          │
    │ ┌──────────────────────────────────────────┐ │
    │ │ Target Backend (Cloud Run / Private VM)  │ │
    │ └──────────────────────────────────────────┘ │
    └──────────────────────────────────────────────┘


## Core Components & Concepts

### 1. Apigee Organization & Tenant Project
* **Apigee Organization:** The top-level container for all API management resources. Bound 1:1 with your GCP Project.
* **Tenant Project:** A dedicated Google-managed GCP project (created automatically behind the scenes). It hosts the Apigee Runtime Data Plane instance, keeping API processing isolated and secure.

### 2. Networking Topology: Service Networking & Private IP
For a simple MVP setup, Apigee X uses **VPC Network Peering via Service Networking** (Service Networking API).
* **VPC Network:** Your standard Google Cloud VPC in your customer project.
* **Allocated IP Range:** A dedicated CIDR block (typically `/22` or `/16`, e.g., `10.0.0.0/22`) allocated strictly for Private Service Access (PSA).
* **Peering Connection:** Connects your customer VPC to the Apigee Tenant Project VPC, allowing internal communication without going over the public internet.

---

## Required Google Cloud APIs

| API Service Name | Display Name | Purpose |
| :--- | :--- | :--- |
| `apigee.googleapis.com` | Apigee API | Provisioning Apigee Organization, Instances, and Proxy Deployments |
| `compute.googleapis.com` | Compute Engine API | Networking, Load Balancers, and PSC NEGs |
| `servicenetworking.googleapis.com` | Service Networking API | Establishing Private Service Access (PSA) peering with Apigee Tenant |
| `cloudresourcemanager.googleapis.com` | Cloud Resource Manager API | Binding IAM roles and provisioning project-level resources |

---

## High-Level Verification Flow

1. **Deploy Terraform Code:** Provisions VPC, PSA Peering, Apigee EVAL Org/Instance, PSC NEG, Global L7 XLB, and a `hello-world` API Proxy.
2. **Execute Test Script (`test-apigee.sh`):**
   * Sends an HTTP request to `https://${LOAD_BALANCER_IP}/hello-world`.
   * Evaluates HTTP status code (`200 OK`) and validates headers attached by the Apigee runtime layer.

---

## High-Level Traffic Flow
1. **Developer / App Request** ➔ Customer VPC / Internal Endpoint
2. **Peering Route** ➔ Service Networking (`servicenetworking-googleapis-com`)
3. **Apigee Tenant Instance** ➔ Receives request, processes policies (Quota, Security, Transformation)
4. **Target Backend (Southbound)** ➔ Proxies call to backend service (Internal GKE/Cloud Run/VM or external API)

