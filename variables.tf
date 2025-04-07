variable "create" {
  description = "Crear recursos"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "vpc"  # Puedes definir un valor predeterminado o dejarlo vacío para ser obligatorio
}

variable "cidr_block_vpc" {
  type = string
  default = "10.0.0.0/16"
}

variable "region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"  # Puedes definir un valor predeterminado o dejarlo vacío para ser obligatorio
}

variable "cidr_public_subnets" {
  description = "CIDR para las subredes públicas"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "cidr_private_subnets" {
  description = "CIDR para las subredes privadas"
  type        = list(string)
  default     = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
  default     = [
    "us-east-1a", 
    "us-east-1b", 
    "us-east-1c"
  ]
}

