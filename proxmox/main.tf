
terraform {
  backend "http" {
    address        = "http://{gitlab_url}/api/v4/projects/4/terraform/state/cluster_state"
    lock_address   = "http://{gitlab_url}/api/v4/projects/4/terraform/state/cluster_state/lock"
    unlock_address = "http://{gitlab_url}/api/v4/projects/4/terraform/state/cluster_state/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
  required_version = ">= 0.13"
}

provider "proxmox" {
  pm_api_url      = var.PROXMOX_TF_IP
  pm_user         = "${var.PROXMOX_TF_USER}@pve"
  pm_password     = var.PROXMOX_TF_PASS
  pm_tls_insecure = "true"
  pm_timeout      = 3600
}

