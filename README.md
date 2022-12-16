# Homelab Proxmox Terraform

This repo contains the terraform configuration required to deploy VMs to
proxmox. The goal of this project was to setup a single resource definition that would be based on 
VM configurations written in .yaml that would reduce the amount of repetition in the .tf files, and
reduce the number of lines required to define a VM in the .yaml files. The default vm settings get 
combined with the yaml configuration (in `locals.tf`) making it so that you can add a new VM to your 
cluster with three lines of yaml:

```yaml
example:
  vmid: 2001
  ipconfig0: "ip={machine_ip_address_here}/24,gw={gateway_ip}"
```

The configuration also exposes most of the attributes in the proxmox resource definition so you can 
add as much detail to the yaml configuration as you need. 

I have this setup on a local deployment of gitlab, and use the gitlab ci/cd to deploy VM definitions. 

This has been a long work-in-progress, there might be some redundant/unused portions still so I'd welcome any code review/feedback. 


## Getting started

If you want to use the make commands outlined below to deploy VM definitions locally, copy/paste 
the contents of `.envexample` into a `.env` file and add all the attributes, then run `source .env`. Also, there is 
a preset variable on line 34 of `variables.tf` for the proxmox ssh user; I chose to define the username here because its
the same for everything I have setup but you should change this part to whatever username you want. 

If you want to setup the gitlab ci/cd pipeline, you'll need to add these environemnt variables under
Settings > CI/CD > Variables. 

Also, take a look through the `variables.tf` and update the URLs to match your gitlab/project API urls.

### Makefile usage

Since there are a lot of `TF_VAR`s I chose to setup a makefile with the commands I've used to mess with terraform. One 
thing I had to do to migrate to this type of terraform repo structure was `mv` all the tf resources from `proxmox_vm_qemu.{vmname}` 
to `proxmox_vm_qemu.proxmox_vm[\"vmname\"]`, which you can do with the makefile command:

```shell
make proxmox-tf-state-move -e from="'proxmox_vm_qemu.{vmname}'" to="'proxmox_vm_qemu.proxmox_vm[\"vmname\"]'"
```

So keep this in mind if you are moving to this type of setup. 

Also, if you currently have VMs defined and want to move to using terraform to manage them, you can use the `proxmox-tf-import` make target. 
For these I had an issue where terraform wanted to destroy and recreate the VMs, so I had to add the attributes that terraform 
said required recreate to the `lifecycle` block on line 38 of the `virtual_machines.tf` so read through the terraform plan 
carefully. 

### Defining New VMs

Virtual machine definitions are added as .yaml files under proxmox/vm_definitions. To see the options 
available for the yaml configuration, look at the `virtual_machines.tf` resource definition (everything that
has `each.value`). 

The yaml definition gets combined with the default configuration for the VM and disk starting at line 71 
of the `variables.tf`. You can update the defaults to match whatever makes sense for your proxmox setup. For
example, I created a VM with ubuntu and setup cloud init on that, and turned it into a template called 'ubuntu-cloudinit'
defined on line 92 of `variables.tf`. 

The only required attributes you need for the yaml definition in order for this to work properly are:

- vmid 
- ipconfig0

but you can add any level of detail per configuration to fit your needs. 

Example:

```yaml
dev:
  vmid: 2000
  cores: 12
  memory: 64000
  ipconfig0: "ip={machine_ip_address_here}/24,gw={gateway_ip}"
  disk:
    size: "101580M"

```

> Note: the .yaml file name should be the first line of the yaml file, so the first line of `dev.yaml` is `dev:` 

## Deploying Proxmox VMs

Locally, in the main repo you can run the following commands to deploy Nomad VMs
to Proxmox:

First, initialize terraform:
```shell
make proxmox_modules-tf-init
```

After perform the terraform plan

```shell
make proxmox_modules-tf-plan
```

Finally, deploy the plan
```shell
make proxmox_modules-tf-apply
```

You can also tear everything down to start from scratch if needed
```shell
make proxmox_modules-tf-destroy
```

If you add/edit any of the terraform configurations, remember to reformat before committing/pushing

```shell
terraform fmt
```

## Setting up gitlab ci/cd

If you want to setup the gitlab ci/cd pipeline, you'll need to add these environemnt variables under
Settings > CI/CD > Variables. 

This project uses gitlab-managed terraform state, so you will need to get that setup first. 

Check the `.gitlab-ci.yml` and update `{gitlab_project_folder}` and `{gitlab_project_url}`. I was having an issue with 
the caching on my gitlab runner, so my solution was to have the runner clone the project and execute the `make` command 
from that folder each time. 

