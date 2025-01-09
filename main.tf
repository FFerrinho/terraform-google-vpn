resource "google_compute_vpn_gateway" "main" {
  count       = var.vpn_gateway_name != null ? 1 : 0
  name        = var.vpn_gateway_name
  network     = var.network
  description = var.vpn_gateway_description
  region      = var.region
  project     = var.project
}

resource "google_compute_ha_vpn_gateway" "main" {
  count              = var.ha_vpn_gateway_name != null ? 1 : 0
  name               = var.ha_vpn_gateway_name
  network            = var.network
  description        = var.vpn_gateway_description
  stack_type         = var.ha_vpn_stack_type
  gateway_ip_version = var.gateway_ip_version
  region             = var.region
  project            = var.project

  dynamic "vpn_interfaces" {
    for_each = var.ha_vpn_interfaces != null ? var.ha_vpn_interfaces : []
    content {
      id                      = vpn_interfaces.value.id
      interconnect_attachment = vpn_interfaces.value.interconnect_attachment
    }

  }
}

resource "google_compute_external_vpn_gateway" "main" {
  count           = var.external_vpn_gateway_name != null ? 1 : 0
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
  for_each                        = var.vpn_tunnel
  name                            = each.value.name
  shared_secret                   = each.value.shared_secret
  description                     = each.value.description
  target_vpn_gateway              = each.value.target_vpn_gateway
  vpn_gateway                     = each.value.vpn_gateway
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  peer_external_gateway           = each.value.peer_external_gateway
  peer_external_gateway_interface = each.value.peer_external_gateway_interface
  peer_gcp_gateway                = each.value.peer_gcp_gateway
  router                          = each.value.router
  peer_ip                         = each.value.peer_ip
  ike_version                     = each.value.ike_version
  local_traffic_selector          = each.value.local_traffic_selector
  remote_traffic_selector         = each.value.remote_traffic_selector
  labels                          = each.value.labels
  region                          = var.region
  project                         = var.project
}
