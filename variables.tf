variable "proxmox_host" {
  description = "Proxmox server hostname or IP address"
  type        = string
}

variable "proxmox_port" {
  description = "Proxmox server port"
  type        = number
  default     = 8006
}

variable "vm_id" {
  description = "Virtual machine ID to retrieve UUID for"
  type        = number
}

variable "node_name" {
  description = "Proxmox node name where the VM is located"
  type        = string
}

variable "pve_api_token" {
  description = "Proxmox API token (format: PVEAPIToken=user@realm!tokenid=secret)"
  type        = string
  default     = null
  sensitive   = true
}

variable "pve_api_token_id" {
  description = "Proxmox API token ID (format: user@realm!tokenid)"
  type        = string
  default     = null
  sensitive   = true
}

variable "pve_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "pve_username" {
  description = "Proxmox username (format: user@realm)"
  type        = string
  default     = null
  sensitive   = true
}

variable "pve_password" {
  description = "Proxmox password"
  type        = string
  default     = null
  sensitive   = true
}

variable "verify_ssl" {
  description = "Whether to verify SSL certificates"
  type        = bool
  default     = true
}
