# 開発者モジュール
module "developer" {
  source = "../modules/developer"

  developer_name        = var.developer_name
  sagemaker_domain_id   = var.sagemaker_domain_id
  listener_priority     = var.listener_priority
  path_name             = var.path_name
  vpc_id                = data.terraform_remote_state.infra.outputs.vpc_id
  public_subnet_ids     = data.terraform_remote_state.infra.outputs.public_subnet_ids
  alb_listener_arn      = data.terraform_remote_state.infra.outputs.alb_listener_arn
  ecs_cluster_arn       = data.terraform_remote_state.infra.outputs.ecs_cluster_arn
  ecs_security_group_id = data.terraform_remote_state.infra.outputs.ecs_security_group_id
  sagemaker_role_arn    = data.terraform_remote_state.infra.outputs.sagemaker_role_arn
  ecs_task_role_arn     = data.terraform_remote_state.infra.outputs.ecs_task_role_arn
  base_image_url        = data.terraform_remote_state.infra.outputs.base_image_url
}
