locals {
  base_configs = {
    for x in fileset("./vm_definitions/", "*") : trimsuffix(x, ".yaml") => merge(var.DEFAULT_VM_SETTINGS, yamldecode(file("./vm_definitions/${x}"))[trimsuffix(x, ".yaml")])
  }
  configs = {
    for id, cfg in local.base_configs : id => merge(cfg, { "disk" : merge(var.DEFAULT_DISK, lookup(cfg, "disk", {})) })
  }
}

