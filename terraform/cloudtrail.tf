###############################################################
# CloudTrail Service Role
###############################################################

resource "aws_iam_role" "cloudtrail_role" {

  name = "${var.project_name}-cloudtrail-role"


  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "cloudtrail.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}


###############################################################
# CloudTrail Policy
###############################################################

resource "aws_iam_role_policy" "cloudtrail_policy" {

  name = "${var.project_name}-cloudtrail-policy"

  role = aws_iam_role.cloudtrail_role.id


  policy = jsonencode({

    Version = "2012-10-17"


    Statement = [

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogStream",

          "logs:PutLogEvents"

        ]

        Resource = "*"

      }

    ]

  })

}



###############################################################
# CloudTrail CloudWatch Log Group
###############################################################

resource "aws_cloudwatch_log_group" "cloudtrail" {

  name = "/aws/cloudtrail/${var.project_name}"


  retention_in_days = 365


  kms_key_id = aws_kms_key.payment_key.arn


  depends_on = [

    aws_kms_key.payment_key

  ]


  tags = {

    Name = "${var.project_name}-cloudtrail-logs"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# CloudTrail Trail
###############################################################

resource "aws_cloudtrail" "main" {


  name = "${var.project_name}-trail"


  s3_bucket_name = aws_s3_bucket.security_logs.id



  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"


  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_role.arn



  include_global_service_events = true


  is_multi_region_trail = true


  enable_log_file_validation = true



  kms_key_id = aws_kms_key.payment_key.arn



  event_selector {


    read_write_type = "All"


    include_management_events = true


    data_resource {


      type = "AWS::S3::Object"


      values = [

        "${aws_s3_bucket.security_logs.arn}/"

      ]

    }


  }



  tags = {

    Name = "${var.project_name}-cloudtrail"

    Compliance = "PCI-DSS"

  }


}


###############################################################
# CloudTrail Bucket Policy
###############################################################

resource "aws_s3_bucket_policy" "cloudtrail_policy" {


  bucket = aws_s3_bucket.security_logs.id


  policy = jsonencode({

    Version = "2012-10-17"


    Statement = [


      {

        Sid = "AWSCloudTrailAclCheck"


        Effect = "Allow"


        Principal = {


          Service = "cloudtrail.amazonaws.com"


        }


        Action = "s3:GetBucketAcl"


        Resource = aws_s3_bucket.security_logs.arn


      },


      {

        Sid = "AWSCloudTrailWrite"


        Effect = "Allow"


        Principal = {


          Service = "cloudtrail.amazonaws.com"


        }


        Action = "s3:PutObject"


        Resource = "${aws_s3_bucket.security_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"


        Condition = {


          StringEquals = {


            "s3:x-amz-acl" = "bucket-owner-full-control"


          }


        }


      }


    ]

  })


}
