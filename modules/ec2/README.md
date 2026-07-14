# Módulo EC2 — Cómputo

## Propósito

Crea una instancia EC2 con Ubuntu 24.04 LTS, cifrado EBS, IMDSv2 obligatorio y tipo restringido a t2.micro.

## Uso

```hcl
module "ec2" {
  source = "./modules/ec2"

  project_name  = "AUY1105-eft"
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_id
  sg_ids        = [module.vpc.ec2_security_group_id]
  key_name      = ""
  common_tags   = { Project = "AUY1105-eft" }
}
```

## Variables

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `project_name` | string | — | Prefijo para nomenclatura |
| `ami_id` | string | — | ID de la AMI (Ubuntu 24.04 LTS) |
| `instance_type` | string | "t2.micro" | Tipo de instancia (solo t2.micro) |
| `subnet_id` | string | — | ID de la subred de despliegue |
| `sg_ids` | list(string) | — | Security Groups asociados |
| `key_name` | string | "" | Key pair SSH (opcional) |
| `common_tags` | map(string) | {} | Tags comunes |

## Outputs

| Output | Descripción |
|--------|-------------|
| `instance_id` | ID de la instancia EC2 |
| `instance_private_ip` | IP privada de la instancia |
| `instance_arn` | ARN de la instancia |

## Seguridad

- IMDSv2 obligatorio (http_tokens = "required") — protección contra SSRF
- Volumen EBS cifrado (AES-256) — CIS AWS 2.2.1
- Tipo restringido a t2.micro por validación

## Dependencias

- Requiere `subnet_id` del módulo VPC
- Requiere `sg_ids` del módulo VPC
