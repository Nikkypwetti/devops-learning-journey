output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.main.name
}

output "website_url" {
  value = "http://${module.alb.alb_dns_name}"
}