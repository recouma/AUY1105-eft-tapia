# ============================================================
# Variables del proyecto raíz
# ============================================================

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en la nomenclatura de recursos (ej: AUY1105-eft)"
  type        = string
  default     = "AUY1105-eft"

  validation {
    condition     = can(regex("^AUY1105-", var.project_name))
    error_message = "El nombre del proyecto debe comenzar con 'AUY1105-' según la nomenclatura del curso."
  }
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser uno de: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Debe ser un bloque CIDR válido."
  }
}

variable "public_subnet_cidr" {
  description = "Bloque CIDR para la subred pública (/24)"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Bloque CIDR para la subred privada (/24)"
  type        = string
  default     = "10.1.2.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para los recursos"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (solo t2.micro permitido por política OPA)"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = var.instance_type == "t2.micro"
    error_message = "Solo se permite el tipo de instancia t2.micro según las políticas de seguridad."
  }
}

variable "key_name" {
  description = "Nombre del key pair para acceso SSH a la instancia EC2 (opcional)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para acceso SSH (NO debe ser 0.0.0.0/0 por política de seguridad)"
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "El acceso SSH público (0.0.0.0/0) no está permitido por las políticas de seguridad."
  }
}
