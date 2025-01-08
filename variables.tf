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
    condition     = contains(["IPV4_ONLY", "IPV4_IPV6", "IPV6_ONLY"], var.ha_vpn_stack_type)
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

variable "vpn_tunnel" {
  description = "The VPN Tunnel(s) for the VPN Gateway."
  type = map(object({
    name                            = optional(string)
    shared_secret                   = optional(string)
    description                     = optional(string)
    target_vpn_gateway              = optional(string)
    vpn_gateway                     = optional(string)
    vpn_gateway_interface           = optional(string)
    peer_external_gateway           = optional(string)
    peer_external_gateway_interface = optional(string)
    peer_gcp_gateway                = optional(string)
    router                          = optional(string)
    peer_ip                         = optional(string)
    ike_version                     = optional(string)
    local_traffic_selector          = optional(list(string))
    remote_traffic_selector         = optional(list(string))
    labels                          = optional(map(string))
  }))
  default = {}
}

variable "remote_router_self_link" {
  description = "The self link for the remote router."
  type        = string
  default     = null

  validation {
    condition     = var.remote_router_self_link == null || can(regex("^projects/[^/]+/regions/[^/]+/routers/[^/]+$", var.remote_router_self_link))
    error_message = "remote_router_self_link must be in the format: projects/{{project}}/regions/{{region}}/routers/{{router}}"
  }
}
