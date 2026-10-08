# terraform-okta-lab

Manage an Okta org's identity config as code: groups, attribute-driven group
rules, test users, a session policy that requires MFA for IT Admins, and an
app assignment. Every change shows up as a `terraform plan` diff before it
touches the tenant, instead of as a click nobody can trace later.

> **Run this only against a free Okta Integrator org** (sign up at
> [developer.okta.com/signup](https://developer.okta.com/signup/), "Integrator
> Free Plan"). It creates and changes users, groups and policies. Never point
> it at a company tenant.

## What's in the repo

| File | Owns |
|---|---|
| `main.tf` | Terraform + provider config, optional HCP Terraform state |
| `groups.tf` | Engineering / IT Admins / New Hires groups, two department-based group rules |
| `users.tf` | Three fake users and a hand-curated New Hires membership |
| `policy.tf` | Global session policy for IT Admins: password + any factor, MFA every session |
| `apps.tf` | Which group gets a test app (skipped until you set an app ID) |
| `outputs.tf` | Group IDs, plus Engineering's real membership read back from Okta |
| `variables.tf` | Org name, API token (sensitive), optional app ID |

Two membership styles sit side by side on purpose: **Engineering** and
**IT Admins** are rule-driven (Terraform owns the rule, Okta computes the
members); **New Hires** is a static list Terraform owns outright.

## Run it

Needs Terraform 1.5+ (`brew install terraform`).

1. Sign up for the Okta Integrator Free Plan (it requires an email on a domain
   you own, not Gmail). Note the subdomain from the Admin Console URL, minus
   any `-admin`: `https://integrator-1234567-admin.okta.com` -> `integrator-1234567`.
2. In the org: **Security > API > Tokens > Create Token**. Copy it once.
3. Put the token in your shell, not in a file:
   ```sh
   export TF_VAR_okta_api_token="<token>"
   ```
4. `cp terraform.tfvars.example terraform.tfvars` and set `okta_org_name`.
5. `terraform init`
6. `terraform plan` should show **11 to add**: 3 groups, 2 group rules,
   3 users, 1 group membership, 1 policy, 1 policy rule.
7. `terraform apply`, then check the Admin Console: groups, rule-driven
   members, the policy under **Security > Global Session Policy**.
8. Optional: create a test app in the Admin Console, put its ID in
   `demo_app_id`, apply again. Plan shows 1 to add: the Engineering assignment.
9. Optional: move state off your laptop with HCP Terraform. Instructions are in
   the commented `cloud` block in `main.tf`.

Clean up with `terraform destroy`.

## The demo

1. `terraform output in_engineering`: Sam is in, Priya and Theo are not.
2. In `users.tf`, change Theo's `department` from `"Sales"` to `"Engineering"`.
3. `terraform plan`: one in-place change, to Theo's profile. Nothing about
   group membership, because Terraform doesn't own it. The rule does.
4. `terraform apply`, then `terraform output in_engineering`: Theo is now
   `true`. That value is read back from Okta after the rule runs, not assumed.

One attribute change, membership follows, no console clicks.

## Limits

- Lab scope. No modules, no environments, no import of existing config.
- Group rules run asynchronously in Okta. `outputs.tf` waits 15 seconds before
  reading membership back; if Okta is slow, run `terraform refresh` and check again.
- The policy uses `primary_factor`, which only exists on Okta Identity Engine
  orgs. Integrator Free Plan orgs are Identity Engine.
- The provider is pinned to `~> 7.0`. Commit `.terraform.lock.hcl` after the
  first `init` so every run uses the same provider build.
- CI runs `terraform fmt -check` and `terraform validate` only. It never has
  credentials and never touches an org.
