###############################################################
# Security Group for VPC Endpoints
###############################################################

resource "aws_security_group" "vpc_endpoint_sg" {


  name = "${var.project_name}-endpoint-sg"



  description = "Allow private access to AWS services"



  vpc_id = aws_vpc.main.id



  ingress {


    from_port = 443


    to_port = 443


    protocol = "tcp"



    security_groups = [


      aws_security_group.ecs_sg.id


    ]



  }



  egress {


    from_port = 0


    to_port = 0


    protocol = "-1"



    cidr_blocks = [


      "0.0.0.0/0"


    ]


  }



}



###############################################################
# Secrets Manager Endpoint
###############################################################

resource "aws_vpc_endpoint" "secrets_manager" {


  vpc_id = aws_vpc.main.id



  service_name = "com.amazonaws.${var.aws_region}.secretsmanager"



  vpc_endpoint_type = "Interface"



  private_dns_enabled = true



  subnet_ids = [


    aws_subnet.private_app_1.id,


    aws_subnet.private_app_2.id


  ]



  security_group_ids = [


    aws_security_group.vpc_endpoint_sg.id


  ]



}



###############################################################
# CloudWatch Logs Endpoint
###############################################################

resource "aws_vpc_endpoint" "logs" {


  vpc_id = aws_vpc.main.id



  service_name = "com.amazonaws.${var.aws_region}.logs"



  vpc_endpoint_type = "Interface"



  private_dns_enabled = true



  subnet_ids = [


    aws_subnet.private_app_1.id,


    aws_subnet.private_app_2.id


  ]



  security_group_ids = [


    aws_security_group.vpc_endpoint_sg.id


  ]



}



###############################################################
# KMS Endpoint
###############################################################

resource "aws_vpc_endpoint" "kms" {


  vpc_id = aws_vpc.main.id



  service_name = "com.amazonaws.${var.aws_region}.kms"



  vpc_endpoint_type = "Interface"



  private_dns_enabled = true



  subnet_ids = [


    aws_subnet.private_app_1.id,


    aws_subnet.private_app_2.id


  ]



  security_group_ids = [


    aws_security_group.vpc_endpoint_sg.id


  ]


}
