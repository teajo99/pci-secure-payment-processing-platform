#############################################
# General Settings
#############################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "production"
}

#############################################
# Network Configuration
#############################################

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_app_subnet_1_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "private_app_subnet_2_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

variable "private_db_subnet_1_cidr" {
  type    = string
  default = "10.0.21.0/24"
}

variable "private_db_subnet_2_cidr" {
  type    = string
  default = "10.0.22.0/24"
}

#############################################
# Database Configuration
#############################################

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "payments"
}

variable "db_username" {
  description = "Database Username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS Instance Type"
  type        = string
  default     = "db.t3.micro"
}

#############################################
# ECS Configuration
#############################################

variable "ecs_cpu" {
  type    = number
  default = 512
}

variable "ecs_memory" {
  type    = number
  default = 1024
}

#############################################
# Domain / HTTPS
#############################################

variable "domain_name" {
  description = "Application Domain"
  type        = string
  default     = "payments.example.com"
}

#############################################
# Alert Email
#############################################

variable "alert_email" {
  description = "SNS Notification Email"
  type        = string
}

#############################################
# Tags
#############################################

variable "project_name" {
  type    = string
  default = "pci-payment-platform"
}

variable "acm_certificate_arn" {

  description = "Existing ACM certificate ARN"

  type = string

}

variable "container_image" {

  description = "Docker image for payment application"

  type = string

}





