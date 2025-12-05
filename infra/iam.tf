# IAMグループ
resource "aws_iam_group" "developers" {
  name = "devenv-developers-group"
}

# IAMグループにPowerUserAccessポリシーをアタッチ
resource "aws_iam_group_policy_attachment" "developers_poweruser" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# 開発者が自分のパスワードを変更できるポリシー
resource "aws_iam_group_policy" "developers_change_password" {
  name  = "devenv-developers-change-password"
  group = aws_iam_group.developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ChangePassword",
          "iam:GetAccountPasswordPolicy"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      }
    ]
  })
}

# SageMaker AI IAM実行ロール
resource "aws_iam_role" "sagemaker" {
  name = "devenv-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# SageMaker実行ロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "sagemaker_full" {
  role       = aws_iam_role.sagemaker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# ECSタスク実行ロール（共通）
resource "aws_iam_role" "ecs_task" {
  name = "devenv-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ECSタスクロールにECRフルアクセスをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_ecr" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# ECSタスクロールにCloudWatch Logsフルアクセスをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_logs" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
