

# EC2 INSTANCE
# -------------------------------------------------------------------------------------
resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.public_subnet_id

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
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
resource "aws_key_pair" "this" {
  key_name   = var.bastion_key_name
  public_key = var.bastion_public_key_name
}
