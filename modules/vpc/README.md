# Módulo VPC — Redes y Seguridad

## Propósito

Crea la infraestructura de red en AWS: VPC, subredes pública y privada, Internet Gateway, Route Table y Security Group con SSH restringido.

## Uso

```hcl
module "vpc" {
  source = "./modules/vpc"

  project_name        = "AUY1105-eft"
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
  availability_zone   = "us-east-1a"
  allowed_ssh_cidr    = "10.1.0.0/16"
  common_tags         = { Project = "AUY1105-eft" }
}
```

## Variables

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `project_name` | string | — | Prefijo para nomenclatura de recursos |
| `vpc_cidr` | string | — | Bloque CIDR de la VPC (ej: 10.1.0.0/16) |
| `public_subnet_cidr` | string | — | CIDR subred pública (/24) |
| `private_subnet_cidr` | string | — | CIDR subred privada (/24) |
| `availability_zone` | string | — | AZ para las subredes |
| `allowed_ssh_cidr` | string | — | CIDR para SSH (NO permite 0.0.0.0/0) |
| `common_tags` | map(string) | {} | Tags comunes |

## Outputs

| Output | Descripción |
|--------|-------------|
| `vpc_id` | ID de la VPC |
| `public_subnet_id` | ID de la subred pública |
| `private_subnet_id` | ID de la subred privada |
| `ec2_security_group_id` | ID del Security Group |
| `internet_gateway_id` | ID del Internet Gateway |

## Seguridad

- SSH restringido al CIDR especificado (validación rechaza 0.0.0.0/0)
- Alineado con CIS AWS Benchmark 5.2

## Dependencias

- Proveedor AWS >= 5.0
- Terraform >= 1.6.0
