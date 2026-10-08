# Terraform owns WHO gets the app. The app itself is created by hand in the
# Admin Console (a free SAML or bookmark test app works). Until its ID is set
# in terraform.tfvars, this resource is simply skipped.

resource "okta_app_group_assignment" "demo_app_to_engineering" {
  count = var.demo_app_id == "" ? 0 : 1

  app_id   = var.demo_app_id
  group_id = okta_group.engineering.id
}
