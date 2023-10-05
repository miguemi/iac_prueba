variable "resource_group_name" {
  type    = string
  default = "POC_INFRA"
}

variable "os_version" {
  type    = string
  default = "2019-datacenter-gensecond"
}

variable "admin_username" {
  type    = string
  default = "patitouser"
}

variable "admin_password" {
  type    = string
  default = "Guatemala2023!"
}

variable "location" {
    type = string
    default = "eastus"
}

variable "vm_name" {
    type  = string
    default = "PatitoVM"
}
