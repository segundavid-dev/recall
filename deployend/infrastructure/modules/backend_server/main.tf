

# EC2 INSTANCE
# -------------------------------------------------------------------------------------
resource "aws_instance" "recall_backend_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.recall_backend_key.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.private_subnet_id
  user_data              = var.user_data

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    delete_on_termination = true

    tags = merge(var.tags, {
      Name = "${var.instance_name}-volume"
    })
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })

}


# KEY PAIR
# -------------------------------------------------------------------------------------
resource "aws_key_pair" "recall_backend_key" {
  key_name   = var.backend_key_name
  public_key = var.backend_public_key_name
}
