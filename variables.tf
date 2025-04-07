variable "create" {
  description = "Crear recursos"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string

}

variable "cidr_block_vpc" {
  type = string
}

variable "region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1" # Puedes definir un valor predeterminado o dejarlo vacío para ser obligatorio
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


