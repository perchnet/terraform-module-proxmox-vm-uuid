#!/bin/bash
set -euo pipefail

input=$(cat)
node=$(echo "${input}" | jq -r '.node')
vmid=$(echo "${input}" | jq -r '.vmid')
host=$(echo "${input}" | jq -r '.host')
api_token_id=$(echo "${input}" | jq -r '.api_token_id // empty')
api_token_secret=$(echo "${input}" | jq -r '.api_token_secret // empty')
username=$(echo "${input}" | jq -r '.username // empty')
password=$(echo "${input}" | jq -r '.password // empty')

base_url="https://${host}:8006/api2/json"

if [[ -n "${api_token}" ]] ; then
    # if ${api_token} begins with "PVEAPIToken=" already:
    if [[ "${api_token}" =~ ^PVEAPIToken=.* ]]; then
        auth_header="Authorization: ${api_token}"
    else
        auth_header="Authorization: PVEAPIToken=${api_token}"
    fi
elif [[ -n "${api_token_id}" && -n "${api_token_secret}" ]]; then
  auth_header="Authorization: PVEAPIToken=${api_token_id}=${api_token_secret}"

  response=$(curl -sk -H "${auth_header}" "${base_url}/nodes/${node}/qemu/${vmid}/config") || {
    jq -n --arg msg "Failed to query Proxmox API with token auth" '{error: $msg}'
    exit 1
  }
elif [[ -n "${username}" && -n "${password}" ]]; then
  auth_response=$(curl -sk -d "username=${username}&password=${password}" "${base_url}/access/ticket") || {
    jq -n --arg msg "Failed to authenticate with username/password" '{error: $msg}'
    exit 1
  }

  ticket=$(echo "${auth_response}" | jq -r '.data.ticket')
  csrf_token=$(echo "${auth_response}" | jq -r '.data.CSRFPreventionToken')

  if [[ -z "${ticket}" || -z "${csrf_token}" || "${ticket}" == "null" || "${csrf_token}" == "null" ]]; then
    jq -n --arg msg "Invalid authentication response: missing ticket or CSRF token" '{error: $msg}'
    exit 1
  fi

  response=$(curl -sk -b "PVEAuthCookie=${ticket}" -H "CSRFPreventionToken: ${csrf_token}" "${base_url}/nodes/${node}/qemu/${vmid}/config") || {
    jq -n --arg msg "Failed to query Proxmox API with username/password" '{error: $msg}'
    exit 1
  }
else
  jq -n --arg msg "No valid authentication method provided" '{error: $msg}'
  exit 1
fi

uuid=$(echo "${response}" | jq -r '.data.smbios1' | sed -n 's/.*uuid=\([^,]*\).*/\1/p')

if [[ -z "${uuid}" ]]; then
  jq -n --arg msg "SMBIOS UUID not found in API response" '{error: $msg}'
  exit 1
fi

jq -n --arg uuid "${uuid}" '{uuid: $uuid}'
