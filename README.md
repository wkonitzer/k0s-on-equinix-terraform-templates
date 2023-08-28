# Bootstrapping MKE cluster on Equinix Metal

This directory provides an example flow for using Mirantis Launchpad with Terraform and Equinix Metal.

## Prerequisites

* An account and credentials for [Equinix Metal](https://deploy.equinix.com/)
* Terraform [installed](https://learn.hashicorp.com/terraform/getting-started/install)
* The Terraform `equinix` provider requires a number of environment variables to be set. Please refer to the [Terraform Equinix Provider](https://registry.terraform.io/providers/equinix/equinix/latest/docs) documentation for more details. The minimum required environment variables for this example are:

  * METAL_AUTH_TOKEN

## Steps

1. Create terraform.tfvars file with needed details. You can use the provided terraform.tfvars.example as a baseline.
2. `terraform init`
3. `terraform apply`
4. `terraform output --raw mke_cluster | launchpad apply --config -`
