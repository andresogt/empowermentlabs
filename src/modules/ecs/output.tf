output "dns_alb" {
  description = "DNS name Load Balancer"
  value       = aws_lb.alb-frontend.dns_name
}

output "sg-backend-id" {
  description =  "ID del segcurity group backend"
  value = aws_security_group.sg_backend.id
}

output "alb_fe_arn" {
  description = "ARN del application load balancer para asociación al WAF empowermentlabs"
  value = aws_lb.alb-frontend.arn
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_empowermentlabs_fe.repository_url
}

output "ecs_name" {
  value = aws_ecs_cluster.cluster_frontend.name
}