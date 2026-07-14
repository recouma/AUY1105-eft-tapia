# ============================================================
# Módulo EC2 — Cómputo
# ============================================================
# Crea una instancia EC2 con Ubuntu 24.04 LTS, tipo t2.micro.
# ============================================================

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.sg_ids
  key_name               = var.key_name != "" ? var.key_name : null

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-ec2"
  })
}
