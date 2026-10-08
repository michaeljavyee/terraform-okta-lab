# Global session policy (okta_policy_signon) scoped to IT Admins: password
# plus any factor, MFA once per session (re-prompt after 60 minutes), 2-hour
# idle timeout, 8-hour session cap. All times are in minutes. Okta's API
# rejects the rule if mfa_lifetime is left out, even though the provider
# marks it optional.
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
  mfa_lifetime       = 60
  session_idle       = 120
  session_lifetime   = 480
  session_persistent = false
}
