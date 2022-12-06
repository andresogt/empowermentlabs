resource "aws_ssm_parameter" "ecs_name" {
  name  = "/empowermentlabs/ecs_front"
  type  = "String"
  value = var.ecs_name
}

resource "aws_ssm_parameter" "ecr_name" {
  name  = "/empowermentlabs/ecr_front"
  type  = "String"
  value = var.ecr_url
}