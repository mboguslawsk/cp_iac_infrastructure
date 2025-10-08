# Infrastructure IaC for Capstone Project

This repository contains the Infrastructure as Code (IaC) setup for the Capstone Project.

## Deployment

1. Manually start the **"IaC Terraform Automation"** pipeline in GitHub.
2. The pipeline will provision all required resources using Terraform.
3. After deployment, resources will be configured using an Ansible playbook (e.g., installing Docker, copying necessary files, etc.).

## Destroying Infrastructure

To remove the infrastructure, simply approve the **destroy job** in the same pipeline. This will clean up and destroy all provisioned resources.
