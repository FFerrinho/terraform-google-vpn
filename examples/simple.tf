module "ha_vpn_external_peer" {
  source = "../"

  project = "my-project"
  region  = "us-central1"
  network = "default"

  # HA VPN Gateway configuration
  ha_vpn_gateway_name = "ha-vpn-external"

  # External peer configuration (required for HA VPN with external peer)
  external_vpn_gateway_name = "external-peer"
  external_vpn_gateway_redundancy_type = "TWO_IPS_REDUNDANCY"
  external_vpn_gateway_interface = [
    {
      id = "0"
      ip_address = "1.2.3.4"
    },
    {
      id = "1"
      ip_address = "5.6.7.8"
    }
  ]

  # VPN tunnels (must specify peer_external_gateway)
  vpn_tunnel = {
    "tunnel-0" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 0
      peer_external_gateway = "projects/my-project/global/externalVpnGateways/external-peer"
      peer_external_gateway_interface = 0
      router = "cloud-router"
    },
    "tunnel-1" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 1
      peer_external_gateway = "projects/my-project/global/externalVpnGateways/external-peer"
      peer_external_gateway_interface = 1
      router = "cloud-router"
    }
  }
}

module "ha_vpn_gcp_peer" {
  source = "../"

  project = "my-project"
  region  = "us-central1"
  network = "default"

  # HA VPN Gateway configuration
  ha_vpn_gateway_name = "ha-vpn-gcp"

  # VPN tunnels (must specify peer_gcp_gateway)
  vpn_tunnel = {
    "tunnel-0" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 0
      peer_gcp_gateway = "projects/peer-project/regions/us-central1/vpnGateways/peer-gateway"
      router = "cloud-router"
    },
    "tunnel-1" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 1
      peer_gcp_gateway = "projects/peer-project/regions/us-central1/vpnGateways/peer-gateway"
      router = "cloud-router"
    }
  }
}
