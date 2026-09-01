output "backend_sg" {
  value = aws_security_group.backend_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "frontend_sg" {
  value = aws_security_group.frontend_sg.id
}

output "bastion_host_sg" {
  value = aws_security_group.bastion_host_sg.id
}

output "internal_alb_sg" {
  value = aws_security_group.internal_alb_sg.id
}