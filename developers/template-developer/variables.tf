variable "developer_name" {
  description = "開発者名（ユーザープロファイル用）"
  type        = string
}

variable "sagemaker_domain_id" {
  description = "既存のSageMaker DomainのID"
  type        = string
}

variable "listener_priority" {
  description = "ALB リスナールールの優先度"
  type        = number
}

variable "path_name" {
  description = "ALB リスナールールのパス名"
  type        = string
}