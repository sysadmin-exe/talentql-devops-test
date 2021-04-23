#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Linux VM 
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#
# - Terraform Block
#

terraform {
  required_providers {
    azurerm = {
      version = ">= 2.20"
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "remote-state"
    storage_account_name = "terraformlearn0702"
    container_name       = "statefilecontainer2"
    key                  = "terraform.tfstate"
  }
}

#
# - Provider Block
#

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}


#
# - Create a Resource Group
#

resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

#
# - Create a Virtual Network
#

resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.vnet_address_range]
  tags                = var.tags
}

#
# - Create a Subnet inside the virtual network
#

resource "azurerm_subnet" "this" {
  name                 = "${var.prefix}-web-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address_range]
}

#
# - Create a Network Security Group
#

resource "azurerm_network_security_group" "this" {
  name                = "${var.prefix}-web-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}


#
# - Subnet-NSG Association
#

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}


#
# - Public IP (To Login to Linux VM)
#

resource "azurerm_public_ip" "this" {
  name                = "${var.prefix}-linuxvm-public-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = var.allocation_method[0]
  tags                = var.tags
}

#
# - Create a Network Interface Card for Virtual Machine
#

resource "azurerm_network_interface" "this" {
  name                = "${var.prefix}-linuxvm-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
  ip_configuration {
    name                          = "${var.prefix}-nic-ipconfig"
    subnet_id                     = azurerm_subnet.this.id
    public_ip_address_id          = azurerm_public_ip.this.id
    private_ip_address_allocation = var.allocation_method[1]
  }
}


#
# - Create a Linux Virtual Machine
# 

resource "azurerm_linux_virtual_machine" "this" {
  name                            = "${var.prefix}-linuxvm"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  network_interface_ids           = [azurerm_network_interface.this.id]
  size                            = var.virtual_machine_size
  computer_name                   = var.computer_name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_key
  }

  os_disk {
    name                 = "${var.prefix}-linuxvm-os-disk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.vm_image_version
  }

  tags = var.tags

}


#
# - Run Custom scripts on the virtual machine using Azure Custom Script VM Extension resource
#

resource "azurerm_virtual_machine_extension" "this" {
  name                 = "LinuxVM-RunScripts"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute"           :  "apt-get -y update && apt-get install -y apache2"
    }
SETTINGS

}