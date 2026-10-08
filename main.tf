# Okta config-as-code lab. Points at a free Okta Integrator (developer) org only.
# Manages groups, attribute-driven group rules, test users, a global session
# policy that requires MFA for IT Admins, and app assignment.

terraform {
  required_version = ">= 1.5"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 7.0"
    }
  }

  # Optional: keep state out of this folder with HCP Terraform (free tier).
  # Create the org + a workspace named "okta-lab", set the workspace's
  # execution mode to "Local" (so TF_VAR_okta_api_token from your shell is
  # used), then uncomment and run `terraform login` + `terraform init`.
  #
  # cloud {
  #   organization = "YOUR_HCP_TERRAFORM_ORG"
  #   workspaces {
  #     name = "okta-lab"
  #   }
  # }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}
