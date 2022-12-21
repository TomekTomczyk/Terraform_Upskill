output "instance1_id" {
  description = "ID of the EC2 instance"
  value       = module.aws_instance1.aws_instance_id
}

output "instance2_id" {
  description = "ID of the EC2 instance"
  value       = module.aws_instance2.aws_instance_id
}
