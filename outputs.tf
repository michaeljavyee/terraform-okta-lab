output "managed_groups" {
  description = "Group IDs to cross-check in the Admin Console"
  value = {
    engineering = okta_group.engineering.id
    it_admins   = okta_group.it_admins.id
    new_hires   = okta_group.new_hires.id
  }
}

# Reads Engineering's actual members back from Okta after every apply.
# Group rules run asynchronously, so the read waits a few seconds first.
# depends_on makes Terraform re-read this at apply time whenever a user or
# rule changes, instead of showing stale membership from plan time.
data "okta_group" "engineering_actual" {
  id                 = okta_group.engineering.id
  include_users      = true
  delay_read_seconds = "15"

  depends_on = [
    okta_user.sam_engineer,
    okta_user.priya_admin,
    okta_user.theo_newhire,
    okta_group_rule.engineering_by_department,
  ]
}

output "in_engineering" {
  description = "Which demo users Okta currently has in Engineering (read back, not assumed)"
  value = {
    sam   = contains(data.okta_group.engineering_actual.users, okta_user.sam_engineer.id)
    priya = contains(data.okta_group.engineering_actual.users, okta_user.priya_admin.id)
    theo  = contains(data.okta_group.engineering_actual.users, okta_user.theo_newhire.id)
  }
}
