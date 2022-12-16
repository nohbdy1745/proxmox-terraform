## These are all the secrets that are stored in the .env and passed into tf
variable "LOCAL_SSH_FILE" {
  type = string
}

variable "PROXMOX_TF_USER" {
  type = string
}

variable "PROXMOX_TF_PASS" {
  type      = string
  sensitive = true
}

variable "PROXMOX_TF_IP" {
  type = string
}

variable "PROXMOX_SSH_KEY" {
  type      = string
  sensitive = true
}

variable "PROXMOX_TOKEN_SECRET" {
  type      = string
  sensitive = true
}

variable "PROXMOX_TOKEN_ID" {
  type      = string
  sensitive = true
}

variable "PROXMOX_SSH_USER" {
  type    = string
  default = "admin"
}

variable "CI_PASSWORD" {
  type      = string
  sensitive = true
}

variable "USER" {
  type = string
}

variable "GIT_PASSWORD" {
  type      = string
  sensitive = true
}

variable "LOCK_ADDRESS" {
  type    = string
  default = "http://{gitlab_url}/api/v4/projects/{project_path}/state/cluster_state/lock"
}

variable "UNLOCK_ADDRESS" {
  type    = string
  default = "http://{gitlab_url}/api/v4/projects/{project_path}/state/cluster_state/lock"
}

variable "ADDRESS" {
  type    = string
  default = "http://{gitlab_url}/api/v4/{project_path}/state/cluster_state"
}

## These are some of the default VM settings for VMs, but can be mostly reused 
## In your configuration be sure to define the IP address

variable "DEFAULT_VM_SETTINGS" {
  type = object({
    clone             = string
    vmid              = number
    count             = number
    target_node       = string
    os_type           = string
    cores             = number
    sockets           = string
    cpu               = string
    memory            = number
    scsihw            = string
    bootdisk          = string
    desc              = string
    vga               = object({})
    os_network_config = string
    ipconfig0         = string
    name              = string
    full_clone        = bool
  })
  default = {
    clone       = "ubuntu-cloudinit"
    vmid        = 1111
    count       = 0
    target_node = "pve"
    os_type     = "cloud-init"
    cores       = 4
    sockets     = "1"
    cpu         = "host"
    memory      = 4000
    scsihw      = "virtio-scsi-pci"
    bootdisk    = "scsi0"
    desc        = "Proxmox VM"
    vga = {
      type = "serial0"
    }
    os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF
    ipconfig0         = ""
    name              = "vm"
    full_clone        = true

  }
}

variable "DEFAULT_VM_DISK" {
  type = object({
    slot         = number
    size         = string
    type         = string
    storage      = string
    storage_type = string
  })
  default = {
    slot         = 0
    size         = "20G"
    type         = "scsi"
    storage      = "local-lvm"
    storage_type = "lvm"
  }
}