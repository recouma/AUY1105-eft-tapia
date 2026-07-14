# ============================================================
# Outputs del proyecto raíz
# ============================================================

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID de la subred pública"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID de la subred privada"
  value       = module.vpc.private_subnet_id
}

output "instance_id" {
  description = "ID de la instancia EC2"
  value       = module.ec2.instance_id
}

output "instance_private_ip" {
  description = "IP privada de la instancia EC2"
  value       = module.ec2.instance_private_ip
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = module.s3.bucket_arn
}
