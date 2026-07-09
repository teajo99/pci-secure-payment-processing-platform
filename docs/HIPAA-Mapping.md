# HIPAA Security Control Mapping


## Access Control

Control:
Limit access to healthcare systems.

Implementation:

- IAM roles
- Least privilege permissions
- Security groups


## Data Protection

Control:
Protect healthcare data.

Implementation:

- KMS encryption
- Encrypted RDS database
- Encrypted S3 storage
- Secrets Manager


## Audit Controls

Control:
Track system activity.

Implementation:

- CloudTrail
- CloudWatch monitoring


## Integrity Controls

Control:
Prevent unauthorised modification.

Implementation:

- S3 versioning
- Backup policies
- Encryption


## Transmission Security

Control:
Protect data communication.

Implementation:

- Private subnets
- Security groups
- Load balancer architecture
