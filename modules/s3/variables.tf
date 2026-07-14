# ============================================================
# Variables del módulo S3
# ============================================================

variable "project_name" {
  description = "Nombre del proyecto para nomenclatura del bucket"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser uno de: dev, staging, prod."
  }
}

variable "common_tags" {
  description = "Tags comunes aplicados a los recursos"
  type        = map(string)
  default     = {}
}
