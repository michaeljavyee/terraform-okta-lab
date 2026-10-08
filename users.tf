# Fake users. `department` drives the group rules in groups.tf.

resource "okta_user" "sam_engineer" {
  first_name = "Sam"
  last_name  = "Engineer"
  login      = "sam.engineer@example-lab.com"
  email      = "sam.engineer@example-lab.com"
  department = "Engineering"
}

resource "okta_user" "priya_admin" {
  first_name = "Priya"
  last_name  = "Admin"
  login      = "priya.admin@example-lab.com"
  email      = "priya.admin@example-lab.com"
  department = "IT"
}

# Theo is the demo user: starts in Sales, then his department changes to
# Engineering and the group rule picks him up. See README "The demo".
resource "okta_user" "theo_newhire" {
  first_name = "Theo"
  last_name  = "Newhire"
  login      = "theo.newhire@example-lab.com"
  email      = "theo.newhire@example-lab.com"
  department = "Sales"
}

# The other management style: New Hires is a hand-curated list, owned
# outright by Terraform. Engineering and IT Admins are rule-driven.
resource "okta_group_memberships" "new_hires" {
  group_id = okta_group.new_hires.id
  users    = [okta_user.theo_newhire.id]
}
