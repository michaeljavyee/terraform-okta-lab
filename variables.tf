variable "okta_org_name" {
  description = "Okta org subdomain, e.g. dev-123456 (the part before .okta.com)"
  type        = string
}

variable "okta_base_url" {
  description = "Okta domain. okta.com for developer orgs."
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Admin API token. Never commit it: pass it with the TF_VAR_okta_api_token environment variable."
  type        = string
  sensitive   = true
}

variable "demo_app_id" {
  description = "App ID of a test app created in the Admin Console. Leave empty to skip the app assignment."
  type        = string
  default     = ""
}
