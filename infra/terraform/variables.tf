variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_cidr" {
  type = list(string)
}

variable "snet_agw_cidr" {
  type = list(string)
}

variable "snet_integration_cidr" {
  type = list(string)
}

variable "snet_private_endpoints_cidr" {
  type = list(string)
}

variable "snet_bastion_cidr" {
  type = list(string)
}

variable "snet_ops_cidr" {
  type = list(string)
}

variable "acr_name" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}

variable "frontend_app_name" {
  type = string
}

variable "backend_app_name" {
  type = string
}

variable "appgw_name" {
  type = string
}

variable "appgw_public_ip_name" {
  type = string
}

variable "appgw_domain_name_label" {
  type    = string
  default = null
}

variable "appgw_custom_hostname" {
  type    = string
  default = null
}

variable "waf_policy_name" {
  type = string
}

variable "appgw_ssl_certificate_name" {
  type    = string
  default = "appgw-tls"
}

variable "appgw_ssl_certificate_secret_id" {
  type      = string
  default   = null
  sensitive = true
}

variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "log_analytics_name" {
  type = string
}

variable "appinsights_frontend_name" {
  type = string
}

variable "appinsights_backend_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "sonarqube_vm_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "public_ssh_key_path" {
  type = string
}
