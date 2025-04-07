output "public_subnet_ids" {
  value = var.create ? aws_subnet.public[*].id : null
}

output "private_subnet_ids" {
  value = var.create ? aws_subnet.private[*].id : null
}

output "vpc_id" {
  value = var.create ? aws_vpc.main[0].id : null
}

