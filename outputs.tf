# Classic VPN Gateway Outputs
output "vpn_gateway" {
  description = "The created VPN Gateway resource"
  value = var.vpn_gateway_name != null ? {
    id         = google_compute_vpn_gateway.main[0].id
    self_link  = google_compute_vpn_gateway.main[0].self_link
    name       = google_compute_vpn_gateway.main[0].name
  } : null
}

# HA VPN Gateway Outputs
output "ha_vpn_gateway" {
  description = "The created HA VPN Gateway resource"
  value = var.ha_vpn_gateway_name != null ? {
    id         = google_compute_ha_vpn_gateway.main[0].id
    self_link  = google_compute_ha_vpn_gateway.main[0].self_link
    name       = google_compute_ha_vpn_gateway.main[0].name
    interfaces = google_compute_ha_vpn_gateway.main[0].vpn_interfaces
  } : null
}

# External VPN Gateway Outputs
output "external_vpn_gateway" {
  description = "The created External VPN Gateway resource"
  value = var.external_vpn_gateway_name != null ? {
    id         = google_compute_external_vpn_gateway.main[0].id
    self_link  = google_compute_external_vpn_gateway.main[0].self_link
    name       = google_compute_external_vpn_gateway.main[0].name
  } : null
}

# VPN Tunnels Output
output "vpn_tunnels" {
  description = "The created VPN Tunnels"
  value = {
    for k, v in google_compute_vpn_tunnel.main : k => {
      id         = v.id
      self_link  = v.self_link
      name       = v.name
      peer_ip    = v.peer_ip
    }
  }
}
