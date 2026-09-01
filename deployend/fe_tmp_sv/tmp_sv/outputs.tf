output "tmp_frontend_public_ip" {
  value = aws_instance.tmp_frontend_server.public_ip
}

output "tmp_frontend_instance_id" {
  value = aws_instance.tmp_frontend_server.id
}

output "tmp_backend_public_ip" {
  value = aws_instance.tmp_backend_server.public_ip
}

output "tmp_backend_instance_id" {
  value = aws_instance.tmp_backend_server.id
}