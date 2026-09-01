output "vpc_id" {
  value = aws_vpc.vpc.id
}


# PRIVATE SUBNETS ID
output "private_subnet_a1_id" {
  value = aws_subnet.private_subnets[0].id
}

output "private_subnet_b1_id" {
  value = aws_subnet.private_subnets[1].id
}

output "private_subnet_c1_id" {
  value = aws_subnet.private_subnets[2].id
}


# PUBLIC SUBNETS ID
output "public_subnet_a1_id" {
  value = aws_subnet.public_subnets[0].id
}

output "public_subnet_b1_id" {
  value = aws_subnet.public_subnets[1].id
}

output "public_subnet_c1_id" {
  value = aws_subnet.public_subnets[2].id
}

output "public_subnet_d1_id" {
  value = aws_subnet.public_subnets[3].id
}