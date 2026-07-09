###############################################################
# ECS Application Log Group
###############################################################

resource "aws_cloudwatch_log_group" "ecs_payment_logs" {

  name = "/ecs/${var.project_name}/payment-api"


  retention_in_days = 365


  kms_key_id = aws_kms_key.payment_key.arn


  depends_on = [

    aws_kms_key.payment_key

  ]


  tags = {

    Name = "${var.project_name}-ecs-logs"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# RDS Error Log Group
###############################################################

resource "aws_cloudwatch_log_group" "rds_logs" {

  name = "/aws/rds/${var.project_name}"


  retention_in_days = 365


  kms_key_id = aws_kms_key.payment_key.arn


  depends_on = [

    aws_kms_key.payment_key

  ]


  tags = {

    Name = "${var.project_name}-rds-logs"

    Compliance = "PCI-DSS"

  }

}



###############################################################
# SNS Security Alerts Topic
###############################################################

resource "aws_sns_topic" "security_alerts" {

  name = "${var.project_name}-security-alerts"


  tags = {

    Name = "${var.project_name}-security-alerts"

  }

}



###############################################################
# SNS Email Subscription
###############################################################

resource "aws_sns_topic_subscription" "security_email" {


  topic_arn = aws_sns_topic.security_alerts.arn


  protocol = "email"


  endpoint = var.alert_email


}



###############################################################
# CloudWatch Alarm - Root Account Usage
###############################################################

resource "aws_cloudwatch_metric_alarm" "root_account_usage" {


  alarm_name = "${var.project_name}-root-account-usage"


  alarm_description = "Alert when root account is used"


  metric_name = "RootAccountUsage"


  namespace = "CloudTrailMetrics"


  statistic = "Maximum"


  period = 300


  evaluation_periods = 1


  threshold = 1


  comparison_operator = "GreaterThanOrEqualToThreshold"



  alarm_actions = [

    aws_sns_topic.security_alerts.arn

  ]

}



###############################################################
# CloudWatch Alarm - Unauthorized API Calls
###############################################################

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {


  alarm_name = "${var.project_name}-unauthorized-api-calls"


  alarm_description = "Detect unauthorized AWS API activity"


  metric_name = "UnauthorizedAttemptCount"


  namespace = "CloudTrailMetrics"


  statistic = "Sum"


  period = 300


  evaluation_periods = 1


  threshold = 1


  comparison_operator = "GreaterThanOrEqualToThreshold"



  alarm_actions = [

    aws_sns_topic.security_alerts.arn

  ]

}



###############################################################
# CloudWatch Dashboard
###############################################################

resource "aws_cloudwatch_dashboard" "payment_dashboard" {


  dashboard_name = "${var.project_name}-dashboard"



  dashboard_body = jsonencode({


    widgets = [


      {

        type = "metric"


        x = 0

        y = 0


        width = 12

        height = 6



        properties = {


          title = "AWS Account Security Monitoring"


          metrics = [


            [

              "CloudTrailMetrics",

              "UnauthorizedAttemptCount"

            ]


          ]


          region = var.aws_region


        }

      }


    ]

  })


}
