resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "ssh_private_key" {
  file_permission = "600"
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "ssh_keys/${var.cluster_name}.pem"
}

resource "local_file" "ssh_public_key" {
  file_permission = "600"
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "ssh_keys/${var.cluster_name}.pub"
}

resource "null_resource" "add_ssh_key_to_agent" {
  provisioner "local-exec" {
    command = <<EOT
      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)"
      fi
      ssh-add ssh_keys/${var.cluster_name}.pem
    EOT
  }

  # This provisioner should only run when the private key is created or changed
  triggers = {
    private_key_checksum = fileexists("ssh_keys/${var.cluster_name}.pem") ? filemd5("ssh_keys/${var.cluster_name}.pem") : ""
  }

  depends_on = [local_file.ssh_private_key]
}

resource "null_resource" "remove_ssh_key_from_agent" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      if [ -n "$SSH_AUTH_SOCK" ]; then
        ssh-add -d ssh_keys/${self.triggers.cluster_name}.pem || true
      fi
    EOT
  }

  triggers = {
    cluster_name = var.cluster_name
  }

  # Ensure this resource depends on the key file, so it’s properly tied to the key’s lifecycle
  depends_on = [local_file.ssh_private_key]
}

resource "equinix_metal_project_ssh_key" "ssh_key_object" {
  name       = "${var.cluster_name}_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
  project_id = var.project_id
}

data "equinix_metal_project_ssh_key" "infra_ssh" {
  depends_on = [equinix_metal_project_ssh_key.ssh_key_object]
  id         = equinix_metal_project_ssh_key.ssh_key_object.id
  project_id = var.project_id
}

resource "equinix_metal_vlan" "vlan" {
  metro       = var.metro
  description = "${var.cluster_name}.vlan"
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "public_ip_block" {
  count       = var.request_ip_block ? 1 : 0  
  project_id  = var.project_id
  quantity    = var.ip_block_size              
  type        = "public_ipv4"
  metro       = var.metro                     
  description = "Public IP Block for ${var.cluster_name}"
}

resource "null_resource" "dependency_trigger" {
  count = var.use_reserved_hardware ? 1 : 0 

  triggers = {
    master_ids = join(",", var.masters_ids)
    worker_ids = join(",", var.workers_ids)
  }
}

resource "null_resource" "delay" {
  count = var.use_reserved_hardware ? 1 : 0
  
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "equinix_metal_gateway" "gateway" {
  depends_on = [null_resource.delay, null_resource.dependency_trigger]
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.vlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.public_ip_block[0].id

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 20"
  }
}
