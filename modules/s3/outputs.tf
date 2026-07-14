# ============================================================
# Outputs del módulo S3
# ============================================================

output "bucket_name" {
  description = "Nombre del bucket S3 creado"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "bucket_region" {
  description = "Región donde se creó el bucket"
  value       = aws_s3_bucket.main.region
}
