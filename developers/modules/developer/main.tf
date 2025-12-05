# IAM ユーザー
resource "aws_iam_user" "developer" {
  name = var.developer_name
}

# IAM ユーザーログインプロファイル
resource "aws_iam_user_login_profile" "developer" {
  user                    = aws_iam_user.developer.name
  password_length         = 8
  password_reset_required = true
}

# IAM ユーザーをグループに所属
resource "aws_iam_user_group_membership" "developer" {
  user = aws_iam_user.developer.name
  groups = ["devenv-developers-group"]
}

# SageMaker AI ユーザープロファイル
resource "aws_sagemaker_user_profile" "developer" {
  domain_id         = var.sagemaker_domain_id
  user_profile_name = var.developer_name

  user_settings {
    execution_role = var.sagemaker_role_arn
  }

  tags = {
    Name = var.developer_name
  }
}

# ALB リスナールール
resource "aws_lb_listener_rule" "developer" {
  listener_arn = var.alb_listener_arn
  priority     = var.listener_priority

  condition {
    path_pattern {
      values = [
        "/${var.path_name}/*"
      ]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.developer.arn
  }
}

# ALB ターゲットグループ
resource "aws_lb_target_group" "developer" {
  name        = "devenv-${var.developer_name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 15
    interval            = 60
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name = "devenv-${var.developer_name}-tg"
  }
}

# ECR
resource "aws_ecr_repository" "developer" {
  name = "devenv-${var.developer_name}-ecr"
}

# ECSサービス
# タスク定義
resource "aws_ecs_task_definition" "developer" {
  family                   = "devenv-${var.developer_name}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_role_arn
  cpu                      = 256
  memory                   = 512


  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.base_image_url
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      # ログ設定
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/devenv-${var.developer_name}-log"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ロググループ
resource "aws_cloudwatch_log_group" "developer" {
  name              = "/ecs/devenv-${var.developer_name}-log"
  retention_in_days = 7
}

# サービス
resource "aws_ecs_service" "developer" {
  name                 = "devenv-${var.developer_name}-service"
  cluster              = var.ecs_cluster_arn
  launch_type          = "FARGATE"
  task_definition      = aws_ecs_task_definition.developer.arn
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.developer.arn
    container_name   = "app"
    container_port   = 8080
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}