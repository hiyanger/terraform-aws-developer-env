# ベースイメージのECRリポジトリ
resource "aws_ecr_repository" "base" {
  name = "devenv-base-ecr"
}

# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "devenv-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "devenv-cluster"
  }
}

# ECSサービス用セキュリティグループ
resource "aws_security_group" "ecs" {
  name        = "devenv-ecs-sg"
  description = "Security group for ECS services"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "From ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devenv-ecs-sg"
  }
}

