terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.5"
    }
  }
  required_version = ">= 1.5"
}
data "external" "vm_uuid" {
  program = ["${path.module}/scripts/get_vm_uuid_curl.sh"]

  query = {
    node             = var.node
    vmid             = var.vmid
    host             = var.host
    api_token        = var.api_token
    api_token_id     = var.api_token_id
    api_token_secret = var.api_token_secret
    username         = var.username
    password         = var.password
  }
}
