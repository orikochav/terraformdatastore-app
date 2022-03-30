data "terraform_remote_state" "project1" {
    backend = "azurerm"
    config = {
        resource_group_name = "terraform-storage-rg"
        storage_account_name = "terraformstateoriko"
        container_name = "tfstatefiles"
        key = "network-terraform.tfstate"
  }
}