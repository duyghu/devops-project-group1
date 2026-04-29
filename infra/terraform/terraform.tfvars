project_name        = "devops-group1"
environment         = "dev"
location            = "italynorth"
resource_group_name = "rg-burgerbuilder-group1"

vnet_cidr                   = ["10.20.0.0/16"]
snet_agw_cidr               = ["10.20.1.0/24"]
snet_integration_cidr       = ["10.20.2.0/24"]
snet_private_endpoints_cidr = ["10.20.3.0/24"]
snet_bastion_cidr           = ["10.20.4.0/26"]
snet_ops_cidr               = ["10.20.5.0/24"]

acr_name              = "acrburgerbuilderdevgroup1"
app_service_plan_name = "asp-burgerbuilder-dev-group1"

frontend_app_name = "app-bb-frontend-dev-group1"
backend_app_name  = "app-bb-backend-dev-group1"

appgw_name           = "agw-burgerbuilder-dev-group1"
appgw_public_ip_name = "pip-agw-burgerbuilder-dev-group1"
# Optional HTTPS inputs:
appgw_domain_name_label       = "burgerbuilder-group1"
appgw_custom_hostname         = "burgerbuilder-group1.italynorth.cloudapp.azure.com"
# appgw_ssl_certificate_secret_id = "https://<your-key-vault-name>.vault.azure.net/secrets/<certificate-secret-name>/<version>"
waf_policy_name      = "waf-burgerbuilder-de-group1"

sql_server_name    = "sql-burgerbuilder-dev-group1"
sql_database_name  = "burgerbuilder-group1"
sql_admin_login    = "sqladminuser"
sql_admin_password = "ChangeThisToAStrongPassword123!"

log_analytics_name        = "law-burgerbuilder-dev-group1"
appinsights_frontend_name = "appi-burgerbuilder-frontend-dev-group1"
appinsights_backend_name  = "appi-burgerbuilder-backend-dev-group1"
key_vault_name            = "kv-dev-groupone"

sonarqube_vm_name   = "vm-sonarqube-dev-group1"
admin_username      = "azureuser"
public_ssh_key_path = "~/.ssh/id_rsa.pub"
