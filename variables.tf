variable "node" {
  type        = string
  description = "Proxmox node name"
}

variable "vmid" {
  type        = string
  description = "Proxmox VM ID"
}

variable "host" {
  type        = string
  description = "Proxmox API host"
}

# The full api token, which may or may not include the "PVEAPIToken=" prefix.
# If left empty will fall back to seperate token + secret
variable "api_token" {
  type        = string
  description = "Proxmox API Token"
  sensitive   = true
  default     = ""
}

variable "api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
  default     = ""
}

variable "api_token_secret" {
  type        = string
  description = "Proxmox API Token Secret"
  default     = ""
}

variable "username" {
  type        = string
  description = "Proxmox username (fallback)"
  default     = ""
}

variable "password" {
  type        = string
  description = "Proxmox password (fallback)"
  default     = ""
}
