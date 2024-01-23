# Generate random pet name to be used as a unique identifier
resource "random_pet" "main" {
  length = 1
}

resource "azurerm_resource_group" "main" {
  name     = "default-resource-group"
  location = var.region
}

resource "azurerm_virtual_network" "default" {
  name                = "default-network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16", "10.179.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "main" {
  name                = "${random_pet.main.id}-vm-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "main" {
  name                = "${random_pet.main.id}-vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${random_pet.main.id}-vm"
  admin_username        = "azureuser"
  admin_password        = "top-secret-password-ah8fg"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_B1ls"

  os_disk {
    name                 = "${random_pet.main.id}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

}