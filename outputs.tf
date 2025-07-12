output "vm_uuid" {
  value     = data.external.vm_uuid.result["uuid"]
  sensitive = true
}
