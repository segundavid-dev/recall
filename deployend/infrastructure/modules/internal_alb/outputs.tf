

output "internal_alb_dns_name" {
  value = aws_lb.internal_alb.dns_name
}

output "internal_alb_zone_id" {
  value = aws_lb.internal_alb.zone_id
}