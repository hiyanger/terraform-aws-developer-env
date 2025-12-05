output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "alb_listener_arn" {
  description = "ALB Listener ARN"
  value       = aws_lb_listener.http.arn
}

output "sagemaker_role_arn" {
  description = "SageMaker実行ロールのARN"
  value       = aws_iam_role.sagemaker.arn
}

output "ecs_cluster_arn" {
  description = "ECSクラスターのARN"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_security_group_id" {
  description = "ECSサービス用セキュリティグループID"
  value       = aws_security_group.ecs.id
}

output "base_image_url" {
  description = "ベースイメージのECR URL"
  value       = "${aws_ecr_repository.base.repository_url}:latest"
}

output "ecs_task_role_arn" {
  description = "ECSタスクロールのARN"
  value       = aws_iam_role.ecs_task.arn
}
