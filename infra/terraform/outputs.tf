output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "frontend_default_hostname" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "backend_default_hostname" {
  value = azurerm_linux_web_app.backend.default_hostname
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}

output "sql_fqdn" {
  value = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "application_gateway_url" {
  value = "http://${azurerm_public_ip.appgw.ip_address}"
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
