###############################################################
# Security Email Subscription
###############################################################

resource "aws_sns_topic_subscription" "security_email_subscription" {


  topic_arn = aws_sns_topic.security_alerts.arn



  protocol = "email"



  endpoint = var.alert_email



}



###############################################################
# GuardDuty Findings Notification
###############################################################

resource "aws_cloudwatch_event_rule" "guardduty_findings" {


  name = "${var.project_name}-guardduty-findings"



  description = "Send GuardDuty findings to SNS"



  event_pattern = jsonencode({


    source = [


      "aws.guardduty"


    ]



    detail-type = [


      "GuardDuty Finding"


    ]


  })


}



###############################################################
# Event Target SNS
###############################################################

resource "aws_cloudwatch_event_target" "guardduty_sns" {


  rule = aws_cloudwatch_event_rule.guardduty_findings.name



  target_id = "SendToSNS"



  arn = aws_sns_topic.security_alerts.arn



}



###############################################################
# Security Hub Findings Notification
###############################################################

resource "aws_cloudwatch_event_rule" "securityhub_findings" {


  name = "${var.project_name}-securityhub-findings"



  event_pattern = jsonencode({


    source = [


      "aws.securityhub"


    ]



    detail-type = [


      "Security Hub Findings - Imported"


    ]


  })


}



resource "aws_cloudwatch_event_target" "securityhub_sns" {


  rule = aws_cloudwatch_event_rule.securityhub_findings.name



  target_id = "SecurityHubSNS"



  arn = aws_sns_topic.security_alerts.arn



}

