resource "google_compute_vpn_gateway" "main" {
  count       = var.vpn_gateway_name
  name        = var.vpn_gateway_name
  network     = var.network
  description = var.vpn_gateway_description
  region      = var.region
  project     = var.project
}

resource "google_compute_ha_vpn_gateway" "main" {
  count              = var.ha_vpn_gateway_name
  name               = var.ha_vpn_gateway_name
  network            = var.network
  description        = var.vpn_gateway_description
  stack_type         = var.ha_vpn_stack_type
  gateway_ip_version = var.gateway_ip_version
  region             = var.region
  project            = var.project

  dynamic "vpn_interfaces" {
    for_each = var.ha_vpn_interfaces
    content {
      id                      = vpn_interfaces.value.id
      interconnect_attachment = vpn_interfaces.value.interconnect_attachment
    }

  }
}

resource "google_compute_external_vpn_gateway" "main" {
  count           = var.external_vpn_gateway_name
  name            = var.external_vpn_gateway_name
  description     = var.vpn_gateway_description
  labels          = var.external_vpn_gateway_labels
  redundancy_type = var.external_vpn_gateway_redundancy_type
  project         = var.project

  dynamic "interface" {
    for_each = var.external_vpn_gateway_interface
    content {
      id         = interface.value.id
      ip_address = interface.value.ip_address
    }
  }

  lifecycle {
    precondition {
      condition = (
        (var.external_vpn_gateway_redundancy_type == "SINGLE_IP_INTERNALLY_REDUNDANT" && alltrue([for i in var.external_vpn_gateway_interface : i.id == 0])) ||
        (var.external_vpn_gateway_redundancy_type == "TWO_IPS_REDUNDANCY" && alltrue([for i in var.external_vpn_gateway_interface : contains([0, 1], i.id)])) ||
        (var.external_vpn_gateway_redundancy_type == "FOUR_IPS_REDUNDANCY" && alltrue([for i in var.external_vpn_gateway_interface : contains([0, 1, 2, 3], i.id)]))
      )
      error_message = "Interface IDs must match the redundancy type: 0 for SINGLE_IP, 0-1 for TWO_IPS, 0-3 for FOUR_IPS"
    }
  }
}

resource "google_compute_vpn_tunnel" "main" {
  count                           = var.vpn_tunnel_name
  name                            = var.vpn_tunnel_name
  shared_secret                   = var.shared_secret
  description                     = var.vpn_tunnel_description
  target_vpn_gateway              = var.vpn_gateway_name != null ? google_compute_vpn_gateway.main[0].self_link : null
  vpn_gateway                     = var.ha_vpn_gateway_name != null ? google_compute_ha_vpn_gateway.main[0].self_link : null
  vpn_gateway_interface           = var.vpn_gateway_interface
  peer_external_gateway           = var.peer_external_gateway
  peer_external_gateway_interface = var.peer_external_gateway_interface
  peer_gcp_gateway                = var.peer_gcp_gateway
  router                          = var.router_name != null ? google_compute_router.main[0].self_link : var.router_self_link
  peer_ip                         = var.peer_ip
  ike_version                     = var.ike_version
  local_traffic_selector          = var.local_traffic_selector
  remote_traffic_selector         = var.remote_traffic_selector
  labels                          = var.vpn_tunnel_labels
  region                          = var.region
  project                         = var.project
}
