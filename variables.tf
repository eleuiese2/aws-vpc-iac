variable "create" {
  description = "Crear recursos"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string

}

variable "enable_dns_hostnames" {
  description = "Habilitar nombres de host DNS"
  type        = bool
  default     = true

}

variable "enable_dns_support" {
  description = "Habilitar soporte DNS"
  type        = bool
  default     = true

}

variable "cidr_block_vpc" {
  type = string
}

variable "region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "cidr_public_subnets" {
  description = "CIDR para las subredes públicas"
  type        = list(string)
}

variable "cidr_private_subnets" {
  description = "CIDR para las subredes privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
}


