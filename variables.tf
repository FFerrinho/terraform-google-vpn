###########################################
#            Common Variables             #
###########################################

variable "network" {
  description = "The network for the VPN Gateway."
  type        = string
}

variable "region" {
  description = "The region for the VPN Gateway."
  type        = string
}

variable "project" {
  description = "The project for the VPN Gateway."
  type        = string
}

###########################################
#              VPN Variables              #
###########################################

variable "vpn_gateway_name" {
  description = "The name for the VPN Gateway."
  type        = string
  default     = null
}

variable "ha_vpn_gateway_name" {
  description = "The name for the VPN Gateway."
  type        = string
  default     = null
}

variable "vpn_gateway_description" {
  description = "A description for the VPN Gateway."
  type        = string
  default     = null
}

variable "ha_vpn_stack_type" {
  description = "The stack type for the VPN Gateway."
  type        = string
  default     = "IPV4_ONLY"

  validation {
    condition     = contains(["IPV4_ONLY", "IPV4_IPV6", "IPV6_ONLY"], var.stack_type)
    error_message = "stack_type must be one of: IPV4_ONLY, IPV4_IPV6, IPV6_ONLY"
  }
}

variable "gateway_ip_version" {
  description = "The IP version for the VPN Gateway."
  type        = string
  default     = "IPV4_ONLY"

  validation {
    condition     = contains(["IPV4", "IPV6"], var.gateway_ip_version)
    error_message = "gateway_ip_version must be one of: IPV4, IPV6"
  }
}

variable "ha_vpn_interfaces" {
  description = "A list of VPN interfaces for the VPN Gateway."
  type = list(object({
    id                      = optional(string)
    interconnect_attachment = optional(string)
  }))
  default = null
}

variable "external_vpn_gateway_name" {
  description = "The name for the External VPN Gateway."
  type        = string
  default     = null

  validation {
    condition     = var.external_vpn_gateway_name == null || can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.external_vpn_gateway_name)) && length(var.external_vpn_gateway_name) <= 63
    error_message = "external_vpn_gateway_name must be between 1 and 63 characters, starting with a letter, ending with a letter or number, and only containing lowercase letters, numbers, and hyphens"
  }
}

variable "external_vpn_gateway_labels" {
  description = "A map of labels for the External VPN Gateway."
  type        = map(string)
  default     = null
}

variable "external_vpn_gateway_redundancy_type" {
  description = "The redundancy type for the External VPN Gateway."
  type        = string
  default     = "SINGLE_IP_INTERNALLY_REDUNDANT"

  validation {
    condition     = contains(["FOUR_IPS_REDUNDANCY", "SINGLE_IP_INTERNALLY_REDUNDANT", "TWO_IPS_REDUNDANCY"], var.external_vpn_gateway_redundancy_type)
    error_message = "external_vpn_gateway_redundancy_type must be one of: FOUR_IPS_REDUNDANCY, SINGLE_IP_INTERNALLY_REDUNDANT, TWO_IPS_REDUNDANCY"
  }
}

variable "external_vpn_gateway_interface" {
  description = "A list of interface for the External VPN Gateway."
  type = list(object({
    id         = optional(string)
    ip_address = optional(string)
  }))
  default = null
}

variable "vpn_tunnel_name" {
  description = "The name for the VPN Tunnel."
  type        = string
}

variable "shared_secret" {
  description = "The shared secret for the VPN Tunnel."
  type        = string
}

variable "vpn_tunnel_description" {
  description = "A description for the VPN Tunnel."
  type        = string
  default     = null
}

variable "vpn_gateway_interface" {
  description = "The VPN Gateway interface for the VPN Tunnel."
  type        = string
  default     = null
}

variable "peer_external_gateway" {
  description = "The peer external gateway for the VPN Tunnel."
  type        = string
  default     = null
}

variable "peer_external_gateway_interface" {
  description = "The peer external gateway interface for the VPN Tunnel."
  type        = string
  default     = null
}

variable "peer_gcp_gateway" {
  description = "The peer GCP gateway for the VPN Tunnel."
  type        = string
  default     = null
}

variable "router_self_link" {
  description = "The router self link for the VPN Tunnel."
  type        = string
  default     = null
}

variable "peer_ip" {
  description = "The peer IP for the VPN Tunnel."
  type        = string
  default     = null
}

variable "ike_version" {
  description = "The IKE version for the VPN Tunnel."
  type        = string
  default     = null

  validation {
    condition     = contains(["1", "2"], var.ike_version)
    error_message = "ike_version must be one of: 1, 2"
  }
}

variable "local_traffic_selector" {
  description = "The local traffic selector for the VPN Tunnel."
  type        = set(string)
  default     = null
}

variable "remote_traffic_selector" {
  description = "The remote traffic selector for the VPN Tunnel."
  type        = set(string)
  default     = null
}

variable "vpn_tunnel_labels" {
  description = "A map of labels for the VPN Tunnel."
  type        = map(string)
  default     = null
}

###########################################
#         Cloud Router Variables          #
###########################################

variable "router_name" {
  description = "The name for the Cloud Router."
  type        = string
}

variable "router_description" {
  description = "A description for the Cloud Router."
  type        = string
  default     = null
}

variable "bgp" {
  description = "A list of BGP configurations for the Cloud Router."
  type = list(object({
    asn                = number
    advertise_mode     = optional(string)
    advertised_groups  = optional(list(string))
    keepalive_interval = optional(number)
    identifier_range   = optional(string)
    advertised_ip_ranges = optional(object({
      range       = string
      description = optional(string)
    }))
  }))
  default = null

  validation {
    condition     = var.bgp == null || alltrue([for b in var.bgp : (b.asn >= 64512 && b.asn <= 65534) || (b.asn >= 4200000000 && b.asn <= 4294967294)])
    error_message = "ASN must be either a 16-bit private ASN (64512-65534) or a 32-bit private ASN (4200000000-4294967294) per RFC6996"
  }
}

variable "router_interface_name" {
  description = "The name for the Router Interface."
  type        = string
  default     = null
}

variable "router_interface_ip_range" {
  description = "The IP range for the Router Interface."
  type        = string
  default     = null
}

variable "router_interface_ip_version" {
  description = "The IP version for the Router Interface."
  type        = string
  default     = "IPV4"

  validation {
    condition     = contains(["IPV4", "IPV6"], var.router_interface_ip_version)
    error_message = "router_interface_ip_version must be one of: IPV4, IPV6"
  }
}

variable "redundant_interface" {
  description = "The redundant interface for the Router Interface."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork for the Router Interface."
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "The private IP address for the Router Interface."
  type        = string
  default     = null
}

variable "router_peer_name" {
  description = "The name for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "router_peer_interface" {
  description = "The interface for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "peer_asn" {
  description = "The peer ASN for the Cloud Router Peer."
  type        = number
  default     = null
}

variable "own_peer_ip_address" {
  description = "The peer IP address for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "peer_ip_address" {
  description = "The peer IP address for the Cloud Router Peer."
  type        = string
  default     = null
}

variable "advertised_route_priority" {
  description = "The advertised route priority for the Cloud Router Peer."
  type        = number
  default     = null
}

variable "advertise_mode" {
  description = "The advertise mode for the Cloud Router Peer."
  type        = string
  default     = null

  validation {
    condition     = contains(["CUSTOM", "DEFAULT"], var.advertise_mode)
    error_message = "advertise_mode must be one of: CUSTOM, DEFAULT"
  }
}

variable "advertised_groups" {
  description = "The advertised groups for the Cloud Router Peer."
  type        = list(string)
  default     = null
}

variable "custom_learned_route_priority" {
  description = "The custom learned route priority for the Cloud Router Peer."
  type        = number
  default     = null

  validation {
    condition     = var.custom_learned_route_priority == null || (var.custom_learned_route_priority >= 0 && var.custom_learned_route_priority <= 65535)
    error_message = "custom_learned_route_priority must be between 0 and 65535"
  }
}

variable "router_peer_enabled" {
  description = "The enabled status for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "advertised_ip_ranges" {
  description = "The advertised IP ranges for the Cloud Router Peer."
  type = list(object({
    range       = string
    description = optional(string)
  }))
  default = null
}

variable "custom_learned_ip_ranges" {
  description = "The custom learned IP ranges for the Cloud Router Peer."
  type = list(object({
    range = string
  }))
  default = null
}

variable "enable_ipv4" {
  description = "The enabled status for IPv4 for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "enable_ipv6" {
  description = "The enabled status for IPv6 for the Cloud Router Peer."
  type        = bool
  default     = null
}

variable "bfd" {
  description = "The BFD configuration for the Cloud Router Peer."
  type = list(object({
    session_initialization_mode = optional(string)
    min_transmit_interval       = optional(number)
    min_receive_interval        = optional(number)
    multiplier                  = optional(number)
  }))
  default = null

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : contains(["ACTIVE", "DISABLED", "PASSIVE"], b.session_initialization_mode)])
    error_message = "session_initialization_mode must be one of: ACTIVE, DISABLED, PASSIVE"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.min_transmit_interval == null || (b.min_transmit_interval >= 1000 && b.min_transmit_interval <= 30000)])
    error_message = "min_transmit_interval must be between 1000 and 30000"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.min_receive_interval == null || (b.min_receive_interval >= 1000 && b.min_receive_interval <= 30000)])
    error_message = "min_receive_interval must be between 1000 and 30000"
  }

  validation {
    condition     = var.bfd == null || alltrue([for b in var.bfd : b.multiplier == null || (b.multiplier >= 5 && b.multiplier <= 16)])
    error_message = "multiplier must be between 5 and 16"
  }
}
