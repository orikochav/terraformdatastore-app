locals {
  web_vm_custom_data = <<CUSTOM_DATA
#!/bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html 
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo "Welcome to amdocs - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
sudo echo "Welcome to amdocs - WebVM App1 - App Status Page" > /var/www/html/app1/status.html
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to amdocs - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
CUSTOM_DATA
}

#resource azure linux virtual machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  
  name = local.vm_name
  computer_name = local.vm_name
  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location =  data.terraform_remote_state.project1.outputs.resource_group_location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  #first vm created attached with first nic second vm it should attach with second nic
  network_interface_ids = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform.pub")
  }
  os_disk {
    name = "osdisk${random_string.myrandom.id}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Redhat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
 # custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")
 custom_data = base64encode(local.web_vm_custom_data)
}