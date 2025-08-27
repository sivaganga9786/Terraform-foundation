output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

# output "private_subnet_ids" {
#   description = "Private subnet IDs"
#   value       = aws_subnet.private[*].id
# }

# output "public_subnet_ids" {
#   description = "Public subnet IDs"
#   value       = aws_subnet.public[*].id
# }


output "public_subnets" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}