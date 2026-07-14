# ============================================================
# Outputs del módulo EC2
# ============================================================

output "instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.main.id
}

output "instance_private_ip" {
  description = "Dirección IP privada de la instancia"
  value       = aws_instance.main.private_ip
}

output "instance_arn" {
  description = "ARN de la instancia EC2"
  value       = aws_instance.main.arn
}
