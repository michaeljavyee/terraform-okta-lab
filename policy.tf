# Global session policy (okta_policy_signon) scoped to IT Admins: password
# plus any factor, MFA once per session, 2-hour idle timeout, 8-hour session
# cap (both in minutes).
#
# primary_factor only applies to Okta Identity Engine orgs, which is what new
# developer orgs are.

resource "okta_policy_signon" "it_admins" {
  name            = "IT Admins - require MFA (Terraform)"
  status          = "ACTIVE"
  description     = "Managed by Terraform. Do not edit in the Admin Console."
  groups_included = [okta_group.it_admins.id]
  priority        = 1
}

resource "okta_policy_rule_signon" "require_mfa" {
  policy_id          = okta_policy_signon.it_admins.id
  name               = "Require MFA every session"
  status             = "ACTIVE"
  access             = "ALLOW"
  primary_factor     = "PASSWORD_IDP_ANY_FACTOR"
  mfa_required       = true
  mfa_prompt         = "SESSION"
  session_idle       = 120
  session_lifetime   = 480
  session_persistent = false
}
