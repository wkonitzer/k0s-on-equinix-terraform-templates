output "mke_cluster" {
  value = yamlencode(local.launchpad_tmpl)
  description = "The launchpad template in yaml format"
}

output "hosts" {
  value       = concat(local.managers, local.workers)
  description = "All hosts in the cluster"
}

output "lb_address_range" {
  value = local.lb_address_range
  description = "load balancer address range"
}
