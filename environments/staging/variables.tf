variable "main_region" {
  type        = string
  description = "main region"
  default     = "eu-west-1"
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "staging"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.small"
}