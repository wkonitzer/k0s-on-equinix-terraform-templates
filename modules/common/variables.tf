variable "cluster_name" {}

variable "project_id" {
  description = "The project ID for the Equinix Metal project."
  type        = string
}

variable "metro" {
  description = "The metro code"
  type        = string
}

variable "request_ip_block" {
  description = "Whether to request a block of public IP addresses."
  type        = bool
  default     = true
}

variable "ip_block_size" {
  description = "The size of the IP block to reserve. For example, 8 for /29, 16 for /28, etc."
  type        = number
  default     = 8
}

variable "use_reserved_hardware" {
  description = "Flag to decide if reserved hardware should be used."
  type        = bool
}

variable "masters_ids" {
  description = "IDs for the master machines"
  type        = list(string)
  default     = []
}

variable "workers_ids" {
  description = "IDs for the worker machines"
  type        = list(string)
  default     = []
}