###############################################################
# Enable Security Hub
###############################################################

resource "aws_securityhub_account" "main" {


  enable_default_standards = true


}



###############################################################
# Enable AWS Foundational Security Best Practices
###############################################################

resource "aws_securityhub_standards_subscription" "aws_best_practices" {


  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"



  depends_on = [


    aws_securityhub_account.main


  ]


}



###############################################################
# Enable CIS AWS Foundations Benchmark
###############################################################

resource "aws_securityhub_standards_subscription" "cis" {


  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0"



  depends_on = [


    aws_securityhub_account.main


  ]


}
