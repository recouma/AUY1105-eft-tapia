# ============================================================
# Módulo S3 — Almacenamiento
# ============================================================
# Crea un bucket S3 con buenas prácticas de seguridad:
# - Acceso público bloqueado
# - Versionado habilitado
# - Cifrado server-side (SSE-S3)
# ============================================================

resource "aws_s3_bucket" "main" {
  bucket = "${lower(var.project_name)}-${var.environment}-bucket"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-s3"
  })
}

# Bloquear acceso público
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Habilitar versionado
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado server-side
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}
