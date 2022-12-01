output "instance1_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.aws_instance1.id
}

output "instance2_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.aws_instance2.id
}

output "instance1_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.aws_instance1.public_ip
}

output "instance2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.aws_instance2.public_ip
}
