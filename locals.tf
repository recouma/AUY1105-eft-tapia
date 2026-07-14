# ============================================================
# Locals — Valores computados y optimización
# ============================================================
# Se usan locals para centralizar valores derivados, evitando
# repetición y mejorando la legibilidad del código.
# ============================================================

locals {
  # Tags comunes aplicados a todos los recursos
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "Daniel Tapia"
      Course      = "AUY1105"
    },
    var.environment == "prod" ? { CriticalLevel = "high" } : {}
  )
}
