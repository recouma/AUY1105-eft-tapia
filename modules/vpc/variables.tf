# ============================================================
# Variables del módulo VPC
# ============================================================

variable "project_name" {
  description = "Nombre del proyecto para nomenclatura de recursos"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC (ej: 10.1.0.0/16)"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Debe ser un bloque CIDR válido."
  }
}

variable "public_subnet_cidr" {
  description = "Bloque CIDR para la subred pública"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Bloque CIDR para la subred privada"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidad para las subredes"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorizado para acceso SSH (no debe ser 0.0.0.0/0)"
  type        = string

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "No se permite SSH público (0.0.0.0/0) por política de seguridad."
  }
}

variable "common_tags" {
  description = "Tags comunes aplicados a todos los recursos del módulo"
  type        = map(string)
  default     = {}
}
