locals {
  # Authentication method selection logic
  has_api_token         = var.pve_api_token != null && var.pve_api_token != ""
  has_token_id_secret   = var.pve_api_token_id != null && var.pve_api_token_secret != null && var.pve_api_token_id != "" && var.pve_api_token_secret != ""
  has_username_password = var.pve_username != null && var.pve_password != null && var.pve_username != "" && var.pve_password != ""

  # Format API token with prefix if needed
  formatted_api_token = local.has_api_token ? (
    startswith(var.pve_api_token, "PVEAPIToken=") ? var.pve_api_token : "PVEAPIToken=${var.pve_api_token}"
  ) : null

  # Construct combined token from ID and secret
  combined_api_token = local.has_token_id_secret ? "PVEAPIToken=${var.pve_api_token_id}=${var.pve_api_token_secret}" : null

  # Determine which authentication method to use
  auth_method = (
    local.has_api_token ? "api_token" :
    local.has_token_id_secret ? "token_id_secret" :
    local.has_username_password ? "username_password" :
    "none"
  )

  # Base URL for Proxmox API
  proxmox_base_url = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"

  # VM status endpoint
  vm_status_url = "${local.proxmox_base_url}/nodes/${var.node_name}/qemu/${var.vm_id}/status/current"
}
