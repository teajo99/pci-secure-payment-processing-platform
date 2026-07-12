# PCI Secure Payment Processing Platform on AWS Using Terraform

![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)
![PCI DSS](https://img.shields.io/badge/PCI%20DSS-Security%20Aligned-0052CC)
![ECS](https://img.shields.io/badge/Compute-ECS%20Fargate-FF9900?logo=amazonecs&logoColor=white)
![Security](https://img.shields.io/badge/Security-Zero%20Trust-blue)
![Encryption](https://img.shields.io/badge/Encryption-AWS%20KMS-success)
![Threat Detection](https://img.shields.io/badge/Threat%20Detection-GuardDuty-red)
![Monitoring](https://img.shields.io/badge/Monitoring-Security%20Hub-purple)

## Project Overview

This project demonstrates the design and deployment of a **PCI-DSS aligned secure payment processing platform** using AWS and Terraform.

The goal was to build a production-style cloud environment that applies security engineering principles used in financial services:

- Network segmentation
- Encryption everywhere
- Identity and access management
- Centralized logging
- Threat detection
- Vulnerability management
- Security monitoring
- Compliance visibility


The platform was designed following the principle of:

> "Assume breach, minimize blast radius, monitor everything."

---

# Business Scenario

A payment processing company requires a secure cloud platform capable of handling sensitive payment workloads.

The platform must protect:

- Payment application workloads
- Database systems
- Audit logs
- Secrets
- Infrastructure configuration


The solution implements a secure AWS architecture that supports PCI DSS security requirements.

---

# Architecture

![image alt](https://github.com/teajo99/pci-secure-payment-processing-platform/blob/4484d239870502d37bc7724f92b59c71fcd95f2e/IMG_5769.gif)

# AWS Services Implemented

## Networking

Implemented:

- Custom VPC
- Public subnets
- Private application subnets
- Private database subnets
- Security Groups
- VPC Endpoints


Security benefits:

- Reduced attack surface
- Private workload communication
- Controlled network access

---

# Identity and Access Management

Implemented:

- IAM roles
- Least privilege policies
- ECS task roles
- Service roles for AWS security services


Security objectives:

- No hardcoded credentials
- Role-based access
- Separation of responsibilities

---

# Encryption

Implemented:

## AWS KMS

Used for:

- Database encryption
- Secrets encryption
- Log encryption


Security controls:

- Customer managed key
- Automatic key rotation
- Restricted key usage


---

# Secrets Management

Implemented:

## AWS Secrets Manager

Used for:

- Database credentials
- Application secrets


Benefits:

- No credentials stored in code
- Centralized secret lifecycle management

---

# Database Security

Implemented:

## Amazon RDS PostgreSQL

Security controls:

- Private subnet deployment
- Encryption at rest
- Restricted security groups
- Backup configuration

---

# Application Security

Implemented:

## ECS Fargate

Features:

- Container-based deployment
- Private networking
- IAM task roles
- CloudWatch logging
- ALB integration


Benefits:

- No server management
- Reduced infrastructure exposure
- Improved scalability

---

# Web Application Protection

Implemented:

## AWS WAF

Protection against:

- SQL injection
- Cross-site scripting
- Common web exploits
- Malicious requests


---

# Logging and Monitoring

Implemented:

## AWS CloudTrail

Purpose:

- API activity tracking
- Audit evidence
- Security investigations


## CloudWatch

Purpose:

- Application logging
- Infrastructure monitoring
- Operational visibility


---

# Threat Detection

## Amazon GuardDuty

Detects:

- Suspicious API activity
- Credential compromise
- Malware behavior
- Network threats


---

# Security Posture Management

## AWS Security Hub

Enabled:

- AWS Foundational Security Best Practices
- CIS AWS Foundations Benchmark


Provides:

- Central security findings
- Compliance visibility
- Security scoring

---

# Configuration Compliance

## AWS Config

Implemented monitoring for:

- Root account MFA
- S3 security configuration
- RDS encryption


Purpose:

Detect:

- Configuration drift
- Security misconfiguration

---

# Vulnerability Management

## Amazon Inspector

Implemented:

- EC2 vulnerability scanning
- Container image scanning
- Lambda vulnerability assessment


---

# Data Protection

## Amazon Macie

Implemented:

- Sensitive data discovery
- S3 data classification


Used to identify:

- Personally identifiable information (PII)
- Sensitive financial data

---

# Alerting

## Amazon SNS

Implemented:

Security notifications for:

- GuardDuty findings
- Security Hub findings
- Security events


---

# PCI DSS Alignment

| PCI DSS Area | Implementation |
|---|---|
| Requirement 1 | Network segmentation and security groups |
| Requirement 2 | Secure AWS configuration |
| Requirement 3 | KMS encryption and secrets protection |
| Requirement 4 | Secure communication design |
| Requirement 6 | Secure application architecture |
| Requirement 8 | IAM access controls |
| Requirement 10 | CloudTrail and CloudWatch logging |
| Requirement 11 | GuardDuty, Security Hub, Inspector |
| Requirement 12 | Security policies and monitoring |

---

# Challenges Encountered During Development

## 1. CloudTrail CloudWatch KMS Permission Issue

### Problem

CloudTrail failed when writing logs to CloudWatch:


AccessDeniedException:
KMS key does not exist or is not allowed


### Root Cause

The KMS key policy did not allow CloudTrail and CloudWatch Logs services to use the key.

### Resolution

Updated the KMS key policy to allow:

- CloudTrail encryption
- CloudWatch Logs encryption
- AWS service access


Lesson learned:

> AWS encryption requires both resource configuration and correct KMS key permissions.

---

# 2. ACM Certificate / HTTPS Listener Failure

### Problem

ALB HTTPS listener failed:


UnsupportedCertificate
CertificateNotFound


### Root Cause

ACM certificates require:

- A real domain name
- DNS validation
- Issued certificate status


### Resolution

For the development environment:

- Removed HTTPS dependency
- Used HTTP ALB temporarily


Production improvement:

- Add Route53
- Add ACM certificate
- Enforce HTTPS only


Lesson learned:

> Cloud services often depend on external validation workflows.

---

# 3. AWS Config Deployment Failure

### Problem

AWS Config failed:


NoAvailableConfigurationRecorderException


### Root Cause

AWS Config requires a strict creation order:

1. Recorder
2. Delivery Channel
3. Enable Recording
4. Config Rules


### Resolution

Added Terraform dependencies using:


depends_on


Lesson learned:

> Infrastructure as Code requires understanding AWS service dependencies.

---

# 4. Inspector Terraform Provider Compatibility

### Problem

Terraform rejected:


auto_enable
tags


### Root Cause

Terraform AWS provider versions have different resource schemas.

### Resolution

Updated the resource definition to match the installed provider version.


Lesson learned:

> Always validate Terraform resources against provider documentation.

---

# Infrastructure as Code Approach

This project was built using:

- Terraform
- AWS Provider
- Declarative infrastructure
- Repeatable deployments


Benefits:

- Version controlled infrastructure
- Repeatable environments
- Reduced manual configuration
- Easier auditing

---

# Deployment

## Initialize Terraform

```bash
terraform init
Validate Configuration
terraform validate
Format Code
terraform fmt
Review Deployment
terraform plan
Deploy
terraform apply
Future Improvements

Production enhancements:

Enable HTTPS with ACM
Add Route53 DNS management
Add AWS Shield Advanced
Add centralized SIEM integration
Add automated compliance reporting
Add CI/CD security scanning
Add Terraform security scanning:
Checkov
tfsec
Terrascan
Skills Demonstrated

## Deployment Status

Successfully deployed to AWS:

- VPC: Created
- ECS Fargate Cluster: Running
- Application Load Balancer: Active
- RDS PostgreSQL: Encrypted
- KMS Encryption: Enabled
- CloudTrail Logging: Enabled
- GuardDuty: Enabled
- Security Hub: Enabled
- AWS Config: Enabled
- Inspector: Enabled
- Macie: Enabled

Deployment Region:

eu-west-2 (London)

This project demonstrates experience with:

AWS Security Engineering
Cloud Architecture
Terraform Infrastructure as Code
PCI DSS Security Controls
IAM Design
Network Security
Container Security
Threat Detection
Compliance Monitoring
Author

Cloud Security Engineering Portfolio Project

Built to demonstrate secure AWS architecture and infrastructure automation.
