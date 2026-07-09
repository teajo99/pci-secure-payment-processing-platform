###############################################################
# Security Logging S3 Bucket
###############################################################

resource "random_id" "bucket_suffix" {

  byte_length = 4

}


resource "aws_s3_bucket" "security_logs" {

  bucket = "${var.project_name}-security-logs-${random_id.bucket_suffix.hex}"


  tags = {

    Name = "${var.project_name}-security-logs"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# Enable Versioning
###############################################################

resource "aws_s3_bucket_versioning" "security_logs" {

  bucket = aws_s3_bucket.security_logs.id


  versioning_configuration {

    status = "Enabled"

  }

}


###############################################################
# Enable Server Side Encryption
###############################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "security_logs" {

  bucket = aws_s3_bucket.security_logs.id


  rule {

    apply_server_side_encryption_by_default {

      kms_master_key_id = aws_kms_key.payment_key.arn

      sse_algorithm = "aws:kms"

    }

  }

}


###############################################################
# Block Public Access
###############################################################

resource "aws_s3_bucket_public_access_block" "security_logs" {

  bucket = aws_s3_bucket.security_logs.id


  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true

}


###############################################################
# Bucket Ownership
###############################################################

resource "aws_s3_bucket_ownership_controls" "security_logs" {

  bucket = aws_s3_bucket.security_logs.id


  rule {

    object_ownership = "BucketOwnerEnforced"

  }

}

###############################################################
# S3 Lifecycle Configuration
###############################################################

resource "aws_s3_bucket_lifecycle_configuration" "security_logs" {


  bucket = aws_s3_bucket.security_logs.id



  rule {


    id = "security-log-retention"



    status = "Enabled"



    filter {


      prefix = ""

    }



    expiration {


      days = 365

    }


  }


}
