# terraform-module-proxmox-vm-uuid

Workaround for Terraform providers for Proxmox not presently returning the UUID for new VMs.

This can be used to keep track of when a VM has been replaced.

Use the module as follows:

```hcl
module "vm_uuid" {
  source = "git::https://github.com/perchnet/terraform-module-proxmox-vm-uuid.git"

  node             = var.node
  vmid             = var.vmid
  host             = var.proxmox_host

  # ONE of the following groups of auth must be specified

  # long API token including both id & secret
  api_token        = var.api_token

  # API token ID and secret
  api_token_id     = var.api_token_id
  api_token_secret = var.api_token_secret

  # username and password
  username         = var.proxmox_username
  password         = var.proxmox_password
}

output "vm_uuid" {
  value     = module.vm_uuid.vm_uuid
}
```
