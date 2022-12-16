
resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each                = { for name, settings in local.configs : name => settings }
  name                    = each.key
  vmid                    = each.value.vmid
  agent                   = 1
  define_connection_info  = true
  cloudinit_cdrom_storage = "local-lvm"
  target_node             = each.value.target_node
  clone                   = each.value.clone
  full_clone              = each.value.full_clone
  os_type                 = "cloud-init"
  cores                   = each.value.cores
  sockets                 = each.value.sockets
  cpu                     = each.value.cpu
  memory                  = each.value.memory
  scsihw                  = each.value.scsihw
  bootdisk                = each.value.bootdisk
  desc                    = each.value.desc
  ssh_user                = "nohbdy"
  vga {
    type = "serial0"
  }

  disk {
    slot     = each.value.disk.slot
    size     = each.value.disk.size
    type     = each.value.disk.type
    storage  = each.value.disk.storage
    iothread = each.value.disk.iothread
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = []
  }
  os_network_config = each.value.os_network_config
  # Cloud Init Settings
  ipconfig0  = each.value.ipconfig0
  sshkeys    = <<EOF
${var.PROXMOX_SSH_KEY}
EOF
  ciuser     = "nohbdy"
  cipassword = var.CI_PASSWORD
}

