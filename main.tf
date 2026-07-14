# ============================================================
# AUY1105 - Evaluación Final Transversal
# Infraestructura como Código II — Daniel Tapia (@recouma)
# ============================================================
# Root module: orquesta los módulos de redes, cómputo y
# almacenamiento para desplegar infraestructura en AWS.
# ============================================================

# -------------------------------------------------------
# Datos: AMI Ubuntu 24.04 LTS (última disponible)
# -------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------------------------------------------
# Módulo de Redes (VPC + Subnets + Security Groups)
# -------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  allowed_ssh_cidr    = var.allowed_ssh_cidr

  common_tags = local.common_tags
}

# -------------------------------------------------------
# Módulo de Cómputo (EC2)
# -------------------------------------------------------
module "ec2" {
  source = "./modules/ec2"

  project_name  = var.project_name
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnet_id
  sg_ids        = [module.vpc.ec2_security_group_id]
  key_name      = var.key_name

  common_tags = local.common_tags
}

# -------------------------------------------------------
# Módulo de Almacenamiento (S3)
# -------------------------------------------------------
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment

  common_tags = local.common_tags
}
