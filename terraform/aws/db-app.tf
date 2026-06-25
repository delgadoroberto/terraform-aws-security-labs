resource "aws_db_instance" "default" {
  name                   = var.dbname
  engine                 = "mysql"
  option_group_name      = aws_db_option_group.default.name
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]

  identifier              = "rds-${local.resource_prefix.value}"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = "20"
  username                = "admin"
  password                = var.password
  apply_immediately       = true
  
  # Mitigación CKV_AWS_157: Alta disponibilidad con Multi-AZ
  multi_az                = true
  
  # Mitigación CKV_AWS_133: Habilitar política de backups (retención > 0 días)
  backup_retention_period = 7
  
  # Mitigación CKV_AWS_16: Cifrado de datos en reposo
  storage_encrypted       = true
  
  skip_final_snapshot     = true
  
  # Mitigación CKV_AWS_118: Monitoreo mejorado habilitado (Intervalo en segundos)
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring_role.arn
  
  # Mitigación CKV_AWS_17: Evitar exposición pública de la base de datos
  publicly_accessible     = false

  # Mitigación CKV_AWS_161: Habilitar autenticación mediante IAM
  iam_database_authentication_enabled = true

  # Mitigación CKV_AWS_226: Permitir actualizaciones automáticas de versiones menores
  auto_minor_version_upgrade = true

  # Mitigación CKV_AWS_293: Prevenir eliminación accidental de la base de datos
  deletion_protection = true

  # Mitigación CKV_AWS_129: Habilitar exportación de logs de auditoría a CloudWatch
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = merge({
    Name        = "${local.resource_prefix.value}-rds"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "e6d83b21346fe85d4fe28b16c0b2f1e0662eb1d7"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2023-04-27 12:47:51"
    git_last_modified_by = "nadler@paloaltonetworks.com"
    git_modifiers        = "nadler/nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "47c13290-c2ce-48a7-b666-1b0085effb92"
  })

  lifecycle {
    ignore_changes = [password]
  }
}

# Rol de IAM necesario para el Enhanced Monitoring de RDS (CKV_AWS_118)
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${local.resource_prefix.value}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_option_group" "default" {
  engine_name              = "mysql"
  name                     = "og-${local.resource_prefix.value}"
  major_engine_version     = "8.0"
  option_group_description = "Terraform OG"

  tags = merge({
    Name        = "${local.resource_prefix.value}-og"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "c8076043-5de7-4203-9a1c-b4e61900628a"
  })
}

resource "aws_db_parameter_group" "default" {
  name        = "pg-${local.resource_prefix.value}"
  family      = "mysql8.0"
  description = "Terraform PG"

  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "immediate"
  }

  tags = merge({
    Name        = "${local.resource_prefix.value}-pg"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "6432b3f9-3f45-4463-befc-2e0f2fbdffc1"
  })
}

resource "aws_db_subnet_group" "default" {
  name        = "sg-${local.resource_prefix.value}"
  subnet_ids  = [aws_subnet.web_subnet.id, aws_subnet.web_subnet2.id]
  description = "Terraform DB Subnet Group"

  tags = merge({
    Name        = "sg-${local.resource_prefix.value}"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "b8368249-50c5-4a24-bdb0-9f83d197b11c"
  })
}

resource "aws_security_group" "default" {
  name        = "${local.resource_prefix.value}-rds-sg"
  description = "Security group for RDS database instance" # Mitigación CKV_AWS_23 (Agregar descripción explicita)
  vpc_id      = aws_vpc.web_vpc.id

  tags = merge({
    Name        = "${local.resource_prefix.value}-rds-sg"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "7b251090-8ac1-4290-bd2e-bf3e16126430"
  })
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  description       = "Allow MySQL ingress traffic from web VPC" # Mitigación CKV_AWS_23
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.web_vpc.cidr_block]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  description       = "Allow outbound traffic" # Mitigación CKV_AWS_23
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # Nota: Idealmente restringir en prod, pero resuelve la falta de descripción
  security_group_id = aws_security_group.default.id
}

### EC2 instance 
resource "aws_iam_instance_profile" "ec2profile" {
  name = "${local.resource_prefix.value}-profile"
  role = aws_iam_role.ec2role.name
  tags = {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "6d33b2b9-2dd3-4915-b5d4-283152c928f1"
  }
}

resource "aws_iam_role" "ec2role" {
  name = "${local.resource_prefix.value}-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Sid = ""
      }
    ]
  })

  tags = merge({
    Name        = "${local.resource_prefix.value}-role"
    Environment = local.resource_prefix.value
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/db-app.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "d4b631c1-c1d0-4986-affb-fb8b94a6a7a5"
  })
}

resource "aws_iam_role_policy" "ec2policy" {
  name = "${local.resource_prefix.value}-policy"
  role = aws_iam_role.ec2role.id

  # Mitigación del acceso excesivo de privilegios (Evitamos comodines nocivos de administración global)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "rds:DescribeDBInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "db_app" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t3.micro" # Actualizado a t3.micro para mejor compatibilidad general
  iam_instance_profile = aws_iam_instance_profile.ec2profile.name

  vpc_security_group_ids = [aws_security_group.web-node.id]
  subnet_id              = aws_subnet.web_subnet.id
  
  # Mitigación CKV_AWS_233: Habilitar monitoreo detallado para EC2
  monitoring             = true

  # Mitigación de cifrado EBS (Asegurar que el volumen raíz herede cifrado o esté explícito)
  root_block_device {
    encrypted   = true
  }

  user_data = <<EOF
#! /bin/bash
sudo yum -y update
sudo yum -y install httpd php php-mysqlnd
sudo systemctl enable httpd 
sudo systemctl start http
