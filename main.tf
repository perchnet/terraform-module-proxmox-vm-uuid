terraform {
  required_version = ">= 1.5"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

# Authentication ticket for username/password method
data "http" "auth_ticket" {
  count = local.auth_method == "username_password" ? 1 : 0

  url      = "${local.proxmox_base_url}/access/ticket"
  method   = "POST"
  insecure = var.insecure

  request_headers = {
    "Content-Type" = "application/x-www-form-urlencoded"
  }

  request_body = "username=${urlencode(var.pve_username)}&password=${urlencode(var.pve_password)}"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to authenticate with Proxmox server. Status code: ${self.status_code}"
    }
  }
}

locals {
  # Extract authentication ticket and CSRF token for username/password method
  auth_response = local.auth_method == "username_password" ? jsondecode(data.http.auth_ticket[0].response_body) : null
  auth_ticket   = local.auth_response != null ? local.auth_response.data.ticket : null
  csrf_token    = local.auth_response != null ? local.auth_response.data.CSRFPreventionToken : null
}

# Get VM configuration and status
data "http" "vm_status" {
  depends_on = [data.http.auth_ticket]

  url      = local.vm_status_url
  method   = "GET"
  insecure = var.insecure

  request_headers = merge(
    {
      "Content-Type" = "application/json"
    },
    # API Token authentication
    local.auth_method == "api_token" ? {
      "Authorization" = local.formatted_api_token
    } : {},
    # Token ID/Secret authentication
    local.auth_method == "token_id_secret" ? {
      "Authorization" = local.combined_api_token
    } : {},
    # Username/Password authentication
    local.auth_method == "username_password" ? {
      "Cookie"              = "PVEAuthCookie=${local.auth_ticket}"
      "CSRFPreventionToken" = local.csrf_token
    } : {}
  )

  lifecycle {
    precondition {
      condition     = local.auth_method != "none"
      error_message = "No valid authentication method provided. Please provide either pve_api_token, pve_api_token_id/pve_api_token_secret, or pve_username/pve_password."
    }

    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to retrieve VM status from Proxmox. Status code: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}

locals {
  # Parse the response to extract VM UUID
  vm_status_response = jsondecode(data.http.vm_status.response_body)
  vm_uuid            = local.vm_status_response.data.uuid
}
