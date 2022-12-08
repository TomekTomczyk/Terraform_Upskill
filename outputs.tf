output "instance1_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.aws_instance1.id
}

output "instance2_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.aws_instance2.id
}
