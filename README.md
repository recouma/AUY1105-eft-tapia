# AUY1105 — Evaluación Final Transversal

> Infraestructura como Código II · DUOC UC · Daniel Tapia (@recouma)

## Propósito

Consolidado de las evaluaciones parciales 1, 2 y 3. Implementa una solución de infraestructura en AWS con Terraform, organizada en módulos reutilizables, con pipeline CI/CD automatizado y políticas de seguridad como código (OPA).

---

## Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                   VPC 10.1.0.0/16                   │
│                                                     │
│  ┌─────────────────┐    ┌─────────────────────────┐ │
│  │ Subred Pública   │    │   Subred Privada         │ │
│  │ 10.1.1.0/24      │    │   10.1.2.0/24            │ │
│  │                  │    │                          │ │
│  │                  │    │  ┌───────────────────┐   │ │
│  │                  │    │  │   EC2 (t2.micro)  │   │ │
│  │                  │    │  │   Ubuntu 24.04    │   │ │
│  │                  │    │  │   EBS cifrado     │   │ │
│  │                  │    │  │   SG: SSH /16     │   │ │
│  │                  │    │  └───────────────────┘   │ │
│  └─────────────────┘    └─────────────────────────┘ │
│           │                                         │
│      ┌────┴────┐                                    │
│      │   IGW   │          ┌──────────────────┐      │
│      └─────────┘          │   S3 Bucket      │      │
│                           │   Cifrado AES256 │      │
│                           │   Versionado ON  │      │
│                           │   Acceso privado │      │
│                           └──────────────────┘      │
└─────────────────────────────────────────────────────┘
```

---

## Pipeline CI/CD

Se activa en cada **Pull Request** hacia `main`. Cuatro etapas secuenciales:

```
TFLint ──► Checkov ──► terraform validate ──► OPA
(estático)  (seguridad)  (sintáctico)          (políticas)
```

| Etapa | Herramienta | Propósito |
|-------|-------------|-----------|
| 1 | **TFLint** | Análisis estático de mejores prácticas Terraform |
| 2 | **Checkov** | Escaneo de vulnerabilidades de seguridad AWS |
| 3 | **terraform validate** | Validación sintáctica y coherencia del código |
| 4 | **OPA** | Evaluación de políticas de seguridad personalizadas |

---

## Módulos

### Módulo VPC (`modules/vpc/`)

Crea la infraestructura de red: VPC, subredes, Internet Gateway, Route Tables y Security Groups.

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `project_name` | string | Prefijo para nomenclatura de recursos |
| `vpc_cidr` | string | Bloque CIDR de la VPC (ej: `10.1.0.0/16`) |
| `public_subnet_cidr` | string | CIDR de la subred pública |
| `private_subnet_cidr` | string | CIDR de la subred privada |
| `availability_zone` | string | AZ para las subredes |
| `allowed_ssh_cidr` | string | CIDR para SSH (no permite `0.0.0.0/0`) |
| `common_tags` | map(string) | Tags comunes |

**Outputs**: `vpc_id`, `public_subnet_id`, `private_subnet_id`, `ec2_security_group_id`

### Módulo EC2 (`modules/ec2/`)

Crea una instancia EC2 con Ubuntu 24.04 LTS, EBS cifrado e IMDSv2 habilitado.

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `project_name` | string | Prefijo para nomenclatura |
| `ami_id` | string | ID de la AMI (Ubuntu 24.04 LTS) |
| `instance_type` | string | Tipo de instancia (solo `t2.micro`) |
| `subnet_id` | string | ID de la subred de despliegue |
| `sg_ids` | list(string) | Security Groups asociados |
| `key_name` | string | Key pair SSH (opcional) |

**Outputs**: `instance_id`, `instance_private_ip`, `instance_arn`

### Módulo S3 (`modules/s3/`)

Crea un bucket S3 con acceso público bloqueado, versionado y cifrado server-side.

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `project_name` | string | Prefijo para nombre del bucket |
| `environment` | string | Ambiente (`dev`, `staging`, `prod`) |

**Outputs**: `bucket_name`, `bucket_arn`, `bucket_region`

---

## Políticas de Seguridad (OPA)

4 políticas Rego v1 alineadas con estándares de la industria:

| Política | Archivo | Estándar |
|----------|---------|----------|
| Denegar SSH público | `deny_public_ssh.rego` | CIS AWS 5.2 |
| Solo t2.micro | `only_t2_micro.rego` | Gobernanza de costos |
| Cifrado EBS obligatorio | `require_encryption.rego` | CIS AWS 2.2.1 |
| Tags obligatorios | `require_tags.rego` | AWS Well-Architected |

### Escenarios de prueba (`tests/`)

| Test | Archivo | Resultado esperado |
|------|---------|-------------------|
| Plan conforme | `plan-conforme.json` | ✅ ALLOW (sin denegaciones) |
| SSH público | `plan-ssh-publico.json` | ❌ DENY |
| Tipo inválido | `plan-tipo-invalido.json` | ❌ DENY |
| Sin cifrado | `plan-sin-cifrado.json` | ❌ DENY |
| Sin tags | `plan-sin-tags.json` | ❌ DENY |

---

## Uso rápido

```bash
# 1. Clonar e inicializar
git clone https://github.com/recouma/AUY1105-eft-tapia.git
cd AUY1105-eft-tapia

# 2. Configurar credenciales AWS (Learner Lab)
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."

# 3. Copiar variables de ejemplo
cp terraform.tfvars.example terraform.tfvars

# 4. Inicializar y desplegar
terraform init
terraform plan
terraform apply

# 5. Verificar políticas OPA localmente
opa eval -d policies/ -i tests/plan-conforme.json "data.terraform.security.deny"
```

---

## Estructura del proyecto

```
AUY1105-eft-tapia/
├── .github/workflows/
│   └── ci.yml                      # Pipeline CI/CD
├── modules/
│   ├── vpc/                        # Módulo de redes
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── ec2/                        # Módulo de cómputo
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   └── s3/                         # Módulo de almacenamiento
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── policies/                       # Políticas OPA (Rego v1)
│   ├── deny_public_ssh.rego
│   ├── only_t2_micro.rego
│   ├── require_encryption.rego
│   └── require_tags.rego
├── tests/                          # Fixtures de prueba OPA
│   ├── plan-conforme.json
│   ├── plan-ssh-publico.json
│   ├── plan-tipo-invalido.json
│   ├── plan-sin-cifrado.json
│   └── plan-sin-tags.json
├── docs/
│   └── informe.md                  # Informe técnico EFT
├── main.tf                         # Root module
├── variables.tf                    # Variables con validación
├── outputs.tf                      # Outputs consolidados
├── locals.tf                       # Valores computados
├── versions.tf                     # Terraform + providers
├── terraform.tfvars.example        # Ejemplo de configuración
├── .gitignore
├── CHANGELOG.md
└── README.md
```

---

## Técnicas de optimización aplicadas

- **Variables con validación**: reglas `validation` en variables críticas (CIDR, instance_type, environment)
- **Locals**: centralización de valores computados y tags, eliminando repetición
- **`merge()`**: composición dinámica de tags comunes + específicos por recurso
- **Expresiones condicionales**: tags adicionales según ambiente (`prod` → `CriticalLevel = high`)
- **`format()`**: construcción estandarizada de nombres de recursos
- **`terraform fmt`**: formateo consistente verificado en CI
- **IMDSv2**: configuración de seguridad avanzada en instancias EC2
- **Módulos separados**: desacoplamiento de responsabilidades (redes, cómputo, almacenamiento)
