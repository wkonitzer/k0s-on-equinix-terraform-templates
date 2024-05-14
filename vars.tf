# Project configuration
# required to export METAL_AUTH_TOKEN=XXXX

variable "project_id" {
  type        = string
  description = <<EOT
ID of your Project in Equinix Metal,
possible to handle as environment variable:
export TF_VAR_project_id="XXXXXXXXXXX"
EOT
}

variable "use_reserved_hardware" {
  description = "Flag to decide if reserved hardware should be used."
  type        = bool
  default     = false
}

variable "cluster_name" {
  default = "k0s"
}

variable "master_count" {
  default = 3
}

variable "worker_count" {
  default = 3
}

variable "metros" {
  description = "List of metros and their reserved hardware."
  type = list(object({
    metro            = string
    reserved_hardware = list(object({
      id   = string
      plan = string
    }))
  }))
}

variable "request_ip_block" {
  description = "Whether to request a block of public IP addresses."
  type        = bool
  default     = true
}

variable "ip_block_size" {
  description = "The size of the IP block to reserve. For example, 8 for /29, 16 for /28, etc."
  type        = number
  default     = 16
}

variable "reserved_ip_addresses" {
  description = "List of reserved IP addresses"
  type        = list(string)
  default     = []
}
