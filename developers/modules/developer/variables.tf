variable "developer_name" {
  description = "開発者名"
  type        = string
}

variable "sagemaker_domain_id" {
  description = "既存のSageMaker DomainのID"
  type        = string
}

variable "sagemaker_role_arn" {
  description = "SageMaker実行ロールのARN"
  type        = string
}

variable "listener_priority" {
  description = "ALB リスナールールの優先度"
  type        = number
}

variable "alb_listener_arn" {
  description = "ALB リスナーのARN"
  type        = string
}

variable "path_name" {
  description = "ALB リスナールールのパス名"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ECSクラスターのARN"
  type        = string
}

variable "public_subnet_ids" {
  description = "パブリックサブネットIDのリスト"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECSサービス用セキュリティグループID"
  type        = string
}

variable "base_image_url" {
  description = "ベースイメージのECR URL"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECSタスクロールのARN"
  type        = string
}