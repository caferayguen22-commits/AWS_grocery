resource "aws_ssm_parameter" "app_env" {
  name  = "/grocerymate/prod/app_env"
  type  = "String"
  value = "production"
}

resource "aws_ssm_parameter" "log_level" {
  name  = "/grocerymate/prod/log_level"
  type  = "String"
  value = "INFO"
}