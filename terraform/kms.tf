###############################################################
# KMS Policy
###############################################################

data "aws_iam_policy_document" "kms_policy" {


  ###############################################################
  # Root Account
  ###############################################################

  statement {

    sid = "EnableRootPermissions"


    effect = "Allow"


    principals {

      type = "AWS"


      identifiers = [

        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

      ]

    }


    actions = [

      "kms:*"

    ]


    resources = [

      "*"

    ]

  }



  ###############################################################
  # CloudTrail
  ###############################################################

  statement {

    sid = "AllowCloudTrail"


    effect = "Allow"


    principals {

      type = "Service"


      identifiers = [

        "cloudtrail.amazonaws.com"

      ]

    }


    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]


    resources = [

      "*"

    ]

  }



  ###############################################################
  # RDS
  ###############################################################

  statement {

    sid = "AllowRDS"


    effect = "Allow"


    principals {

      type = "Service"


      identifiers = [

        "rds.amazonaws.com"

      ]

    }


    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]


    resources = [

      "*"

    ]

  }



  ###############################################################
  # Secrets Manager
  ###############################################################

  statement {

    sid = "AllowSecretsManager"


    effect = "Allow"


    principals {

      type = "Service"


      identifiers = [

        "secretsmanager.amazonaws.com"

      ]

    }


    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]


    resources = [

      "*"

    ]

  }



  ###############################################################
  # CloudWatch Logs
  ###############################################################

  statement {

    sid = "AllowCloudWatchLogs"


    effect = "Allow"


    principals {

      type = "Service"


      identifiers = [

        "logs.amazonaws.com"

      ]

    }


    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:ReEncrypt*",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]


    resources = [

      "*"

    ]

  }



  ###############################################################
  # AWS Config
  ###############################################################

  statement {

    sid = "AllowAWSConfig"


    effect = "Allow"


    principals {

      type = "Service"


      identifiers = [

        "config.amazonaws.com"

      ]

    }


    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]


    resources = [

      "*"

    ]

  }



}



###############################################################
# KMS Key
###############################################################

resource "aws_kms_key" "payment_key" {


  description = "PCI Secure Payment Platform Encryption Key"


  deletion_window_in_days = 30


  enable_key_rotation = true


  policy = data.aws_iam_policy_document.kms_policy.json



  tags = {


    Name = "${var.project_name}-kms-key"


    Compliance = "PCI-DSS"


  }


}



###############################################################
# KMS Alias
###############################################################

resource "aws_kms_alias" "payment_alias" {


  name = "alias/pci-payment-key"


  target_key_id = aws_kms_key.payment_key.key_id


}
