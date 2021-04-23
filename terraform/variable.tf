#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Linux VM - Variables
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#Service Principal Variables

variable "client_id" {
  description = "Client ID (APP ID) of the application"
  type        = string
}

variable "client_secret" {
  description = "Client Secret (Password) of the application"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

# Prefix and Tags

variable "prefix" {
  description = "Prefix to append to all resource names"
  type        = string
  default     = "talentql"
}

variable "tags" {
  description = "Resouce tags"
  type        = map(string)
  default = {
    "author"        = "Victor"
    "deployed_with" = "Terraform"
    "purpose"       = "TalentQL_Test"
  }
}

# Resource Group

variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "East US"
}

# Vnet and Subnet

variable "vnet_address_range" {
  description = "IP Range of the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_range" {
  description = "IP Range of the virtual network"
  type        = string
  default     = "10.0.1.0/24"
}

# Public IP and NIC Allocation Method

variable "allocation_method" {
  description = "Allocation method for Public IP Address and NIC Private ip address"
  type        = list(string)
  default     = ["Static", "Dynamic"]
}


# VM 

variable "virtual_machine_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B1s"
}

variable "computer_name" {
  description = "Computer name"
  type        = string
  default     = "apacheserver"
}

variable "admin_username" {
  description = "Username to login to the VM"
  type        = string
  default     = "linuxadmin"
}

variable "ssh_key" {
  description = "ssh public to login to the VM"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL0aH6Gc5FheGfwCI1pW/Zo1KEkqQcHe3ODaA9wMgnlQ6vOdA4chOVHWHIIJuMNKVoQ6oaE2XjDRMNNq4QXhpo8ssiJc4DS//D5ckJbej5YsQGMt4Bhn9JV3tSAY7RASzip9FAIbAu82QCUkM3DsKKu9yDSLjP3sa088riGjR2atlMiERoSL6dCOhUeUco1C0EF1JiVHIk0ZksPEVJ0J5YC8PCH3lphMpmAi/irle0jbLx4jFXy9RliYY5W7BBGVJ+b+rAqwRmSgYUHDXkQjsfXXIp3564C4RjYeo0kpUYqGhvQnbpiw18xx1spHaaa471miHRHAR3knTN/npObS35uLXzpMTbp+mJc8O/O/sCyakngA1SwobMxQcC3MUUx3xYPhnumnDYLL3Am+c0DX6sUN3yyhH1BBjkEwAFV0WiXONJBom1ktit326yLxysMAn31FKSS3AkafQH7kgVyk1DO/63MBVaO55Y/Qcz3+Xez3tobELnzAjsoEMmuMg7SZ0= victorefedi@Victors-MacBook-Pro.local"
}
variable "admin_password" {
  description = "Password to login to the VM"
  type        = string
  default     = "P@$$w0rD2020*"
}

variable "os_disk_caching" {
  default = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  default = "StandardSSD_LRS"
}

variable "os_disk_size_gb" {
  default = 64
}

variable "publisher" {
  default = "Canonical"
}

variable "offer" {
  default = "UbuntuServer"
}

variable "sku" {
  default = "16.04-LTS"
}

variable "vm_image_version" {
  default = "latest"
}
