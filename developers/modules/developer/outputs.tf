output "iam_user_password" {
  description = "IAMユーザーのパスワード"
  value       = nonsensitive(aws_iam_user_login_profile.developer.password)
}