## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_external_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_external_vpn_gateway) | resource |
| [google_compute_ha_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ha_vpn_gateway) | resource |
| [google_compute_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_vpn_gateway) | resource |
| [google_compute_vpn_tunnel.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_vpn_tunnel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_vpn_gateway_interface"></a> [external\_vpn\_gateway\_interface](#input\_external\_vpn\_gateway\_interface) | A list of interface for the External VPN Gateway. | <pre>list(object({<br>    id         = optional(string)<br>    ip_address = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_external_vpn_gateway_labels"></a> [external\_vpn\_gateway\_labels](#input\_external\_vpn\_gateway\_labels) | A map of labels for the External VPN Gateway. | `map(string)` | `null` | no |
| <a name="input_external_vpn_gateway_name"></a> [external\_vpn\_gateway\_name](#input\_external\_vpn\_gateway\_name) | The name for the External VPN Gateway. | `string` | `null` | no |
| <a name="input_external_vpn_gateway_redundancy_type"></a> [external\_vpn\_gateway\_redundancy\_type](#input\_external\_vpn\_gateway\_redundancy\_type) | The redundancy type for the External VPN Gateway. | `string` | `"SINGLE_IP_INTERNALLY_REDUNDANT"` | no |
| <a name="input_gateway_ip_version"></a> [gateway\_ip\_version](#input\_gateway\_ip\_version) | The IP version for the VPN Gateway. | `string` | `"IPV4"` | no |
| <a name="input_ha_vpn_gateway_name"></a> [ha\_vpn\_gateway\_name](#input\_ha\_vpn\_gateway\_name) | The name for the VPN Gateway. | `string` | `null` | no |
| <a name="input_ha_vpn_interfaces"></a> [ha\_vpn\_interfaces](#input\_ha\_vpn\_interfaces) | A list of VPN interfaces for the VPN Gateway. | <pre>list(object({<br>    id                      = optional(string)<br>    interconnect_attachment = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ha_vpn_stack_type"></a> [ha\_vpn\_stack\_type](#input\_ha\_vpn\_stack\_type) | The stack type for the VPN Gateway. | `string` | `"IPV4_ONLY"` | no |
| <a name="input_network"></a> [network](#input\_network) | The network for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region for the VPN Gateway. | `string` | n/a | yes |
| <a name="input_remote_router_self_link"></a> [remote\_router\_self\_link](#input\_remote\_router\_self\_link) | The self link for the remote router. | `string` | `null` | no |
| <a name="input_vpn_gateway_description"></a> [vpn\_gateway\_description](#input\_vpn\_gateway\_description) | A description for the VPN Gateway. | `string` | `null` | no |
| <a name="input_vpn_gateway_name"></a> [vpn\_gateway\_name](#input\_vpn\_gateway\_name) | The name for the VPN Gateway. | `string` | `null` | no |
| <a name="input_vpn_tunnel"></a> [vpn\_tunnel](#input\_vpn\_tunnel) | The VPN Tunnel(s) for the VPN Gateway. | <pre>map(object({<br>    shared_secret                   = optional(string)<br>    description                     = optional(string)<br>    target_vpn_gateway              = optional(string)<br>    vpn_gateway                     = optional(string)<br>    vpn_gateway_interface           = optional(string)<br>    peer_external_gateway           = optional(string)<br>    peer_external_gateway_interface = optional(string)<br>    peer_gcp_gateway                = optional(string)<br>    router                          = optional(string)<br>    peer_ip                         = optional(string)<br>    ike_version                     = optional(string)<br>    local_traffic_selector          = optional(list(string))<br>    remote_traffic_selector         = optional(list(string))<br>    labels                          = optional(map(string))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_vpn_gateway"></a> [external\_vpn\_gateway](#output\_external\_vpn\_gateway) | The created External VPN Gateway resource |
| <a name="output_ha_vpn_gateway"></a> [ha\_vpn\_gateway](#output\_ha\_vpn\_gateway) | The created HA VPN Gateway resource |
| <a name="output_vpn_gateway"></a> [vpn\_gateway](#output\_vpn\_gateway) | The created VPN Gateway resource |
| <a name="output_vpn_tunnels"></a> [vpn\_tunnels](#output\_vpn\_tunnels) | The created VPN Tunnels |
