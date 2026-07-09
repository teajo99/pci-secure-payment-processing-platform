###############################################################
# AWS WAF Web ACL
###############################################################

resource "aws_wafv2_web_acl" "payment_waf" {


  name = "${var.project_name}-waf"



  scope = "REGIONAL"



  default_action {


    allow {}

  }



  visibility_config {


    cloudwatch_metrics_enabled = true



    metric_name = "${var.project_name}-waf"



    sampled_requests_enabled = true


  }



  ###############################################################
  # AWS Managed Common Rules
  ###############################################################

  rule {


    name = "AWSManagedRulesCommonRuleSet"



    priority = 1



    override_action {


      none {}

    }



    statement {


      managed_rule_group_statement {


        name = "AWSManagedRulesCommonRuleSet"



        vendor_name = "AWS"


      }


    }



    visibility_config {


      cloudwatch_metrics_enabled = true



      metric_name = "CommonRules"



      sampled_requests_enabled = true


    }


  }



  ###############################################################
  # SQL Injection Protection
  ###############################################################

  rule {


    name = "AWSManagedSQLiRuleSet"



    priority = 2



    override_action {


      none {}

    }



    statement {


      managed_rule_group_statement {


        name = "AWSManagedRulesSQLiRuleSet"



        vendor_name = "AWS"


      }


    }



    visibility_config {


      cloudwatch_metrics_enabled = true



      metric_name = "SQLInjectionRules"



      sampled_requests_enabled = true


    }


  }



  ###############################################################
  # Known Bad Inputs
  ###############################################################

  rule {


    name = "AWSManagedKnownBadInputs"



    priority = 3



    override_action {


      none {}

    }



    statement {


      managed_rule_group_statement {


        name = "AWSManagedRulesKnownBadInputsRuleSet"



        vendor_name = "AWS"


      }


    }



    visibility_config {


      cloudwatch_metrics_enabled = true



      metric_name = "BadInputs"



      sampled_requests_enabled = true


    }


  }


}



###############################################################
# Attach WAF to ALB
###############################################################

resource "aws_wafv2_web_acl_association" "payment_alb_waf" {


  resource_arn = aws_lb.payment_alb.arn



  web_acl_arn = aws_wafv2_web_acl.payment_waf.arn


}
