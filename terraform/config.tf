###############################################################
# Configuration Recorder
###############################################################

resource "aws_config_configuration_recorder" "main" {


  name = "${var.project_name}-config-recorder"



  role_arn = aws_iam_role.config_role.arn



  recording_group {


    all_supported = true


    include_global_resource_types = true


  }


}



###############################################################
# Delivery Channel
###############################################################

###############################################################
# AWS Config Delivery Channel
###############################################################

resource "aws_config_delivery_channel" "main" {


  name = "${var.project_name}-config-channel"



  s3_bucket_name = aws_s3_bucket.security_logs.id



  s3_key_prefix = "config"



  snapshot_delivery_properties {


    delivery_frequency = "TwentyFour_Hours"


  }



  depends_on = [

    aws_s3_bucket_policy.config_bucket_policy

  ]

}



###############################################################
# Enable Recording
###############################################################

resource "aws_config_configuration_recorder_status" "main" {


  name = aws_config_configuration_recorder.main.name



  is_enabled = true



  depends_on = [

    aws_config_delivery_channel.main

  ]



}



###############################################################
# Config Rule - Root MFA
###############################################################

resource "aws_config_config_rule" "root_account_mfa" {


  name = "${var.project_name}-root-account-mfa"



  source {


    owner = "AWS"



    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"


  }



  depends_on = [

    aws_config_configuration_recorder_status.main

  ]


}



###############################################################
# Config Rule - S3 Public Access
###############################################################

resource "aws_config_config_rule" "s3_public_access" {


  name = "${var.project_name}-s3-public-access"



  source {


    owner = "AWS"



    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"


  }



  depends_on = [

    aws_config_configuration_recorder_status.main

  ]


}



###############################################################
# Config Rule - RDS Encryption
###############################################################

resource "aws_config_config_rule" "rds_encryption" {


  name = "${var.project_name}-rds-encryption"



  source {


    owner = "AWS"



    source_identifier = "RDS_STORAGE_ENCRYPTED"


  }



  depends_on = [

    aws_config_configuration_recorder_status.main

  ]


}

###############################################################
# AWS Config S3 Bucket Policy
###############################################################

resource "aws_s3_bucket_policy" "config_bucket_policy" {


  bucket = aws_s3_bucket.security_logs.id



  policy = jsonencode({


    Version = "2012-10-17"



    Statement = [


      {


        Sid = "AWSConfigBucketPermissionsCheck"



        Effect = "Allow"



        Principal = {


          Service = "config.amazonaws.com"


        }



        Action = [

          "s3:GetBucketAcl",

          "s3:ListBucket"

        ]



        Resource = aws_s3_bucket.security_logs.arn



      },


      {


        Sid = "AWSConfigBucketDelivery"



        Effect = "Allow"



        Principal = {


          Service = "config.amazonaws.com"


        }



        Action = [

          "s3:PutObject"

        ]



        Resource = "${aws_s3_bucket.security_logs.arn}/config/*"



        Condition = {


          StringEquals = {


            "s3:x-amz-acl" = "bucket-owner-full-control"


          }


        }


      }


    ]


  })


}