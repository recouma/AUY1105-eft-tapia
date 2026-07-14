# Setup en WSL — Paso a paso

## 1. Instalar herramientas necesarias

```bash
# Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
chmod 755 opa && sudo mv opa /usr/local/bin/

# TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# AWS CLI (si no lo tienes)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Verificar versiones
terraform version
opa version
tflint --version
aws --version
```

## 2. Crear el repositorio en GitHub

```bash
# Crear repo en GitHub (desde la web o con gh CLI)
# Nombre: AUY1105-eft-tapia

# Clonar y copiar los archivos
cd ~
git clone https://github.com/recouma/AUY1105-eft-tapia.git
cd AUY1105-eft-tapia

# Copiar todos los archivos del proyecto aquí
# (los que te generé)
```

## 3. Configurar credenciales AWS (Learner Lab)

```bash
# Ir a AWS Academy → Learner Lab → AWS Details → Copy credentials
# Pegar en terminal:
export AWS_ACCESS_KEY_ID="tu_access_key"
export AWS_SECRET_ACCESS_KEY="tu_secret_key"
export AWS_SESSION_TOKEN="tu_session_token"
export AWS_DEFAULT_REGION="us-east-1"

# Verificar
aws sts get-caller-identity
```

## 4. Flujo de trabajo con PRs (IMPORTANTE para la rúbrica)

```bash
# === PR 1: Estructura inicial ===
git checkout -b feature/estructura-inicial
# Agregar: .gitignore, CHANGELOG.md, README.md, versions.tf, variables.tf, locals.tf
git add .
git commit -m "feat: estructura inicial del proyecto con configuración base"
git push origin feature/estructura-inicial
# → Crear PR en GitHub, agregar descripción detallada, luego merge

# === PR 2: Módulos de infraestructura ===
git checkout main && git pull
git checkout -b feature/modulos-infra
# Agregar: modules/vpc/*, modules/ec2/*, modules/s3/*, main.tf, outputs.tf
git add .
git commit -m "feat: módulos VPC, EC2 y S3 con variables parametrizadas"
git push origin feature/modulos-infra
# → Crear PR con descripción de cada módulo, merge

# === PR 3: Pipeline CI/CD ===
git checkout main && git pull
git checkout -b feature/pipeline-cicd
# Agregar: .github/workflows/ci.yml
git add .
git commit -m "feat: pipeline CI/CD con TFLint, Checkov, Validate y OPA"
git push origin feature/pipeline-cicd
# → Crear PR → el pipeline se ejecutará automáticamente, merge

# === PR 4: Políticas OPA y tests ===
git checkout main && git pull
git checkout -b feature/politicas-opa
# Agregar: policies/*, tests/*
git add .
git commit -m "feat: 4 políticas OPA (SSH, tipo, cifrado, tags) con 5 escenarios de prueba"
git push origin feature/politicas-opa
# → Crear PR → pipeline debe pasar en verde, merge

# === PR 5: Documentación y informe ===
git checkout main && git pull
git checkout -b feature/documentacion
# Agregar: docs/informe.md, actualizar README.md
git add .
git commit -m "docs: informe técnico EFT y documentación completa"
git push origin feature/documentacion
# → Crear PR, merge

# === Tag de versión final ===
git checkout main && git pull
git tag -a v1.0.0 -m "v1.0.0: Release consolidado EFT"
git push origin v1.0.0
# → Crear Release en GitHub con descripción
```

## 5. Validar localmente antes de la presentación

```bash
# Terraform
cd ~/AUY1105-eft-tapia
terraform init -backend=false
terraform validate
terraform fmt -check -recursive

# OPA tests
echo "=== Test conforme ==="
opa eval -d policies/ -i tests/plan-conforme.json "data.terraform.security.deny"
# Debe dar: []

echo "=== Test SSH público ==="
opa eval -d policies/ -i tests/plan-ssh-publico.json "data.terraform.security.deny"
# Debe dar mensaje de DENY

echo "=== Test tipo inválido ==="
opa eval -d policies/ -i tests/plan-tipo-invalido.json "data.terraform.security.deny"
# Debe dar mensaje de DENY

echo "=== Test sin cifrado ==="
opa eval -d policies/ -i tests/plan-sin-cifrado.json "data.terraform.security.deny"
# Debe dar mensaje de DENY

echo "=== Test sin tags ==="
opa eval -d policies/ -i tests/plan-sin-tags.json "data.terraform.security.deny"
# Debe dar mensaje de DENY
```

## 6. Despliegue real en Learner Lab (opcional pero impresiona)

```bash
# Configurar credenciales del Learner Lab (paso 3)
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Guardar evidencias
terraform output > evidencias/outputs.txt
terraform show > evidencias/terraform-show.txt

# Al terminar, destruir
terraform destroy
```
