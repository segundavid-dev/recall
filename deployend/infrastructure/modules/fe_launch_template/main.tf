# -------------------------------------------------------
# AMI
# -------------------------------------------------------
resource "aws_ami_from_instance" "frontend_ami" {
  name               = var.frontend_ami_name
  source_instance_id = var.frontend_instance_id

  description = "Ami created for Autoscaling group"

  tags = merge(
    var.tags,
    {
      Name = var.frontend_ami_name
    }
  )
}


resource "aws_ami_from_instance" "backend_ami" {
  name               = var.backend_ami_name
  source_instance_id = var.backend_instance_id

  description = "Ami for backend server"

  tags = merge(
    var.tags,
    {
      Name = var.backend_ami_name
    }
  )
}


# -------------------------------------------------------
#  LAUNCH TEMPLATE  
# -------------------------------------------------------
resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.lt_name}-"

  image_id               = aws_ami_from_instance.frontend_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = var.security_group_ids


  monitoring {
    enabled = false
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name = var.instance_name
      },
      var.tags
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.tags, {
        Name = var.instance_name
    })
  }


  tags = merge(
    var.tags,
    {
      Name = var.lt_name
    }
  )
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.frontend_key_name
  public_key = var.frontend_public_key_name
}





