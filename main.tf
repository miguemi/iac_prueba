resource "azurerm_resource_group" "res-0" {
  location = "${var.location}"
  name     = "${var.resource_group_name}"
}
resource "azurerm_managed_disk" "res-1" {
  create_option        = "Empty"
  location             = "${var.location}"
  name                 = "${var.vm_name}-disk"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "StandardSSD_LRS"
  disk_size_gb         = 128
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_windows_virtual_machine" "res-2" {
  admin_password        = "${var.admin_password}"
  admin_username        = "${var.admin_username}"
  location              = "${var.location}"
  name                  = "${var.vm_name}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = [azurerm_network_interface.res-4.id]
  secure_boot_enabled   = true
  size                  = "Standard_DS1_v2"
  vtpm_enabled          = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-datacenter-gensecond"

    
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-4,
  ]
}
resource "azurerm_virtual_machine_data_disk_attachment" "res-3" {
  caching            = "ReadWrite"
  lun                = 0
  virtual_machine_id = azurerm_windows_virtual_machine.res-2.id
  managed_disk_id    = azurerm_managed_disk.res-1.id
  
  depends_on = [
    azurerm_managed_disk.res-1,
    azurerm_windows_virtual_machine.res-2,
  ]
}
resource "azurerm_network_interface" "res-4" {
  enable_accelerated_networking = true
  location                      = "${var.location}"
  name                          = "${var.vm_name}-nic"
  resource_group_name           = "${var.resource_group_name}"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.res-10.id
    public_ip_address_id          = azurerm_public_ip.res-8.id
    
  }
  depends_on = [
    azurerm_public_ip.res-8,
    azurerm_subnet.res-10,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-5" {
  network_interface_id = azurerm_network_interface.res-4.id
  network_security_group_id = azurerm_network_security_group.res-6.id

  depends_on = [
    azurerm_network_interface.res-4,
    azurerm_network_security_group.res-6,
    
  ]
}
resource "azurerm_network_security_group" "res-6" {
  location            = "${var.location}"
  name                = "${var.vm_name}-nsg"
  resource_group_name = "${var.resource_group_name}"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_network_security_rule" "res-7" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = "${var.vm_name}-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "${var.resource_group_name}"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-6,
  ]
}
resource "azurerm_public_ip" "res-8" {
  allocation_method   = "Static"
  location            = "${var.location}"
  name                = "${var.vm_name}-ip"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_virtual_network" "res-9" {
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  name                = "${var.vm_name}-vnet"
  resource_group_name = "${var.resource_group_name}"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-10" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.vm_name}-vnet"
  depends_on = [
    azurerm_virtual_network.res-9,
  ]
}
