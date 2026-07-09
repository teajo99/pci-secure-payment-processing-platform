###############################################################
# VPC Output
###############################################################

output "vpc_id" {


  value = aws_vpc.main.id


}



###############################################################
# ALB DNS
###############################################################

output "application_load_balancer_dns" {


  value = aws_lb.payment_alb.dns_name


}



###############################################################
# ECS Cluster
###############################################################

output "ecs_cluster_name" {


  value = aws_ecs_cluster.payment_cluster.name


}



###############################################################
# RDS Endpoint
###############################################################

output "database_endpoint" {


  value = aws_db_instance.payment_database.endpoint



  sensitive = true


}



###############################################################
# Security Bucket
###############################################################

output "security_logs_bucket" {


  value = aws_s3_bucket.security_logs.bucket


}



###############################################################
# KMS Key ID
###############################################################

output "kms_key_id" {


  value = aws_kms_key.payment_key.key_id


}



###############################################################
# GuardDuty Detector
###############################################################

output "guardduty_detector_id" {


  value = aws_guardduty_detector.main.id


}

