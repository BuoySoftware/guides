output "id" {
  description = "ID of the created resource."
  value       = aws_security_group.main.id
}

output "arn" {
  description = "ARN of the created resource."
  value       = aws_security_group.main.arn
}
