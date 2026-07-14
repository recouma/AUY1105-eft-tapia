# ============================================================
# Variables del módulo EC2
# ============================================================

variable "project_name" {
  description = "Nombre del proyecto para nomenclatura"
  type        = string
}

variable "ami_id" {
  description = "ID de la AMI a utilizar (Ubuntu 24.04 LTS)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (debe ser t2.micro por política)"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = var.instance_type == "t2.micro"
    error_message = "Solo se permite t2.micro según la política de seguridad."
  }
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegará la instancia"
  type        = string
}

variable "sg_ids" {
  description = "Lista de IDs de Security Groups a asociar"
  type        = list(string)
}

variable "key_name" {
  description = "Nombre del key pair SSH (vacío = sin key pair)"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Tags comunes aplicados a los recursos"
  type        = map(string)
  default     = {}
}
