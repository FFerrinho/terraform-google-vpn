module "full_ha_vpn" {
  source = "../"

  project = "my-project"
  region  = "us-central1"
  network = "default"

  ha_vpn_gateway_name = "full-ha-vpn"

  # External peer configuration
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

  # VPN tunnels with both peer types
  vpn_tunnel = {
    # Tunnels to external peer
    "external-0" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 0
      peer_external_gateway = "projects/my-project/global/externalVpnGateways/external-peer"
      peer_external_gateway_interface = 0
      router = "cloud-router"
    },
    "external-1" = {
      shared_secret = "secret123"
      vpn_gateway_interface = 1
      peer_external_gateway = "projects/my-project/global/externalVpnGateways/external-peer"
      peer_external_gateway_interface = 1
      router = "cloud-router"
    },
    # Tunnels to GCP peer
    "gcp-0" = {
      shared_secret = "secret456"
      vpn_gateway_interface = 0
      peer_gcp_gateway = "projects/peer-project/regions/us-central1/vpnGateways/peer-gateway"
      router = "cloud-router-2"
    },
    "gcp-1" = {
      shared_secret = "secret456"
      vpn_gateway_interface = 1
      peer_gcp_gateway = "projects/peer-project/regions/us-central1/vpnGateways/peer-gateway"
      router = "cloud-router-2"
    }
  }
}
