locals {
  
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  #common tags
  service_name = "Demo Service"
  owner = "Ori Kochav"
  common_tags = {
      Service = local.service_name
      Owner = local.owner
  }

  #vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
}