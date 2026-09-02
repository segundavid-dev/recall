output "launch_template_id" {
  value = aws_launch_template.launch_template.id
}

output "backend_ami_id" {
  value = aws_ami_from_instance.backend_ami.id
}