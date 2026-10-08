# Department groups managed as code. The description is deliberate: anyone
# who opens these in the Admin Console sees that Terraform owns them.

resource "okta_group" "engineering" {
  name        = "Engineering"
  description = "Managed by Terraform. Do not edit in the Admin Console."
}

resource "okta_group" "it_admins" {
  name        = "IT Admins"
  description = "Managed by Terraform. Do not edit in the Admin Console."
}

resource "okta_group" "new_hires" {
  name        = "New Hires"
  description = "Managed by Terraform. Do not edit in the Admin Console."
}

# Membership driven by the user's department attribute. Change the attribute,
# Okta's group rule moves the user. Terraform owns the rule, not the members.
resource "okta_group_rule" "engineering_by_department" {
  name              = "Engineering by department attribute"
  status            = "ACTIVE"
  group_assignments = [okta_group.engineering.id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.department==\"Engineering\""
}

resource "okta_group_rule" "it_admins_by_department" {
  name              = "IT Admins by department attribute"
  status            = "ACTIVE"
  group_assignments = [okta_group.it_admins.id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.department==\"IT\""
}
