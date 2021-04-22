#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Linux VM - Outputs
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

output "resource-group-name" {
    description     =   "Print the name of the resource group"
    value           =   azurerm_resource_group.this.name
}

output "resource-group-location" {
    description     =   "Print the location of the resource group"
    value           =   azurerm_resource_group.this.location
}

output "virtual-network-name" {
    description     =   "Print the name of the virtual network"
    value           =   azurerm_virtual_network.this.name
}

output "virtual-network-ip-range" {
    description     =   "Print the ip range of the virtual network"
    value           =   azurerm_virtual_network.this.address_space
}

output "subnet-name" {
    description     =   "Print the name of the subnet"
    value           =   azurerm_subnet.this.name
}

output "subnet-ip-range" {
    description     =   "Print the ip range of the subnet"
    value           =   [azurerm_subnet.this.address_prefixes]
}

output "linux_nic_name" {
    value           =   azurerm_network_interface.this.name
}

output "public_ip_address" {
    value           =   azurerm_public_ip.this.ip_address
}

output "linux_vm_login" {
    value           = {
        "username"  =   azurerm_linux_virtual_machine.this.admin_username
    }  
}
