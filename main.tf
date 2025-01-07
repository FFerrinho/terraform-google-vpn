resource "google_compute_vpn_getway" "main" {
  count       = var.vpn_gateway_name
  name        = var.vpn_gateway_name
  network     = var.network
  description = var.vpn_description
  region      = var.region
  project     = var.project
}

resource "google_compute_ha_vpn_gateway" "main" {
  count              = var.ha_vpn_gateway_name
  name               = var.ha_vpn_gateway_name
  network            = var.network
  description        = var.vpn_description
  stack_type         = var.stack_type
  gateway_ip_version = var.gateway_ip_version
  region             = var.region
  project            = var.project

  dynamic "vpn_interfaces" {
    for_each = var.vpn_interfaces
    content {
      id                      = vpn_interfaces.value.id
      interconnect_attachment = vpn_interfaces.value.interconnect_attachment
    }

  }
}

resource "google_compute_router" "main" {
  count       = var.router_name
  name        = var.router_name
  network     = var.network
  description = var.router_description
  region      = var.region
  project     = var.project

  dynamic "bgp" {
    for_each = var.bgp
    content {
      asn                = bgp.value.asn != null ? bgp.value.asn : ""
      advertise_mode     = bgp.value.advertise_mode != null ? bgp.value.advertise_mode : ""
      advertised_groups  = bgp.value.advertised_groups != null ? bgp.value.advertised_groups : ""
      keepalive_interval = bgp.value.keepalive_interval != null ? bgp.value.keepalive_interval : ""
      identifier_range   = bgp.value.identifier_range != null ? bgp.value.identifier_range : ""

      dynamic "advertised_ip_ranges" {
        for_each = bgp.value.advertised_ip_ranges
        content {
          range       = advertised_ip_ranges.value.range != null ? advertised_ip_ranges.value.range : ""
          description = advertised_ip_ranges.value.description != null ? advertised_ip_ranges.value.description : ""
        }
      }
    }
  }
}

resource "google_compute_vpn_tunnel" "main" {
  name                            = vpn_tunnel_name
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

resource "google_compute_router_interface" "main" {
  count               = var.router_interface_name
  name                = var.router_interface_name
  router              = var.router_name != null ? google_compute_router.main[0].self_link : var.router_self_link
  ip_range            = var.router_interface_ip_range
  ip_version          = var.router_interface_ip_version
  vpn_tunnel          = var.vpn_tunnel_name != null ? google_compute_vpn_tunnel.main[0].self_link : null
  redundant_interface = var.redundant_interface
  project             = var.project
  subnetwork          = var.subnetwork
  private_ip_address  = var.private_ip_address
  region              = var.region
}

resource "google_compute_router_peer" "main" {
  name                          = var.router_peer_name
  interface                     = var.router_peer_interface
  peer_asn                      = var.peer_asn
  router                        = var.router_name != null ? google_compute_router.main[0].self_link : var.router_self_link
  ip_address                    = var.own_peer_ip_address
  peer_ip_address               = var.peer_ip_address
  advertised_route_priority     = var.advertised_route_priority
  advertise_mode                = var.advertise_mode
  advertised_groups             = var.advertised_groups
  custom_learned_route_priority = var.custom_learned_route_priority
  enable                        = var.router_peer_enabled
  enable_ipv4                   = var.enable_ipv4
  enable_ipv6                   = var.enable_ipv6
  region                        = var.region
  project                       = var.project

  dynamic "advertised_ip_ranges" {
    for_each = var.advertised_ip_ranges
    content {
      range       = advertised_ip_ranges.value.range
      description = advertised_ip_ranges.value.description
    }
  }

  dynamic "custom_learned_ip_ranges" {
    for_each = var.custom_learned_ip_ranges
    content {
      range = custom_learned_ip_ranges.value.range
    }
  }

  dynamic "bfd" {
    for_each = var.bfd
    content {
      session_initialization_mode = bfd.value.session_initialization_mode
      min_transmit_interval       = bfd.value.min_transmit_interval
      min_receive_interval        = bfd.value.min_receive_interval
      multiplier                  = bfd.value.multiplier
    }
  }

  lifecycle {
    precondition {
      condition     = var.advertise_mode != "CUSTOM" ? length(var.advertised_groups) == 0 : true
      error_message = "advertised_groups can only be used when advertise_mode is set to CUSTOM"
    }
    precondition {
      condition     = var.advertise_mode != "CUSTOM" ? length(var.advertised_ip_ranges) == 0 : true
      error_message = "advertised_ip_ranges can only be used when advertise_mode is set to CUSTOM"
    }
  }
}
