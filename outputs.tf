output "vm_uuid" {
  description = "The UUID of the virtual machine"
  value       = local.vm_uuid
}

output "vm_status" {
  description = "The current status of the virtual machine"
  value       = local.vm_status_response.data.status
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = try(local.vm_status_response.data.name, null)
}

output "authentication_method_used" {
  description = "The authentication method that was used"
  value       = local.auth_method
}

output "proxmox_api_url" {
  description = "The Proxmox API URL that was used"
  value       = local.proxmox_base_url
}