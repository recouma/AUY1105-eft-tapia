# Módulo S3 — Almacenamiento

## Propósito

Crea un bucket S3 con acceso público bloqueado, versionado habilitado y cifrado server-side AES-256.

## Uso

```hcl
module "s3" {
  source = "./modules/s3"

  project_name = "AUY1105-eft"
  environment  = "dev"
  common_tags  = { Project = "AUY1105-eft" }
}
```

## Variables

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `project_name` | string | — | Prefijo para nombre del bucket |
| `environment` | string | — | Ambiente (dev, staging, prod) |
| `common_tags` | map(string) | {} | Tags comunes |

## Outputs

| Output | Descripción |
|--------|-------------|
| `bucket_name` | Nombre del bucket S3 |
| `bucket_arn` | ARN del bucket |
| `bucket_region` | Región del bucket |

## Seguridad

- Acceso público bloqueado (4 opciones en true)
- Versionado habilitado (recuperación ante borrado)
- Cifrado server-side AES-256 con bucket key

## Dependencias

- Ninguna — módulo independiente
- Proveedor AWS >= 5.0
