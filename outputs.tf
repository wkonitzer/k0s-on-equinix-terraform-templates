output "k0s_cluster" {
  value = templatefile("${path.module}/k0s_cluster.yaml.tmpl", {
    cluster_name = var.cluster_name
    hosts = concat(local.managers, local.workers)
  })
  description = "The k0sctl template in yaml format"
}

output "metallb_l2" {
  value = templatefile("${path.module}/metallb-l2-pool.yaml.tmpl", {
    lb_address_range = local.lb_address_range
  })
  description = "The metallb config in yaml format"
}

output "hosts" {
  value       = concat(local.managers, local.workers)
  description = "All hosts in the cluster"
}

output "lb_address_range" {
  value = local.lb_address_range
  description = "load balancer address range"
}
