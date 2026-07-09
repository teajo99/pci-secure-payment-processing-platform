###############################################################
# Application Load Balancer
###############################################################

resource "aws_lb" "payment_alb" {

  name = "${var.project_name}-alb"

  internal = false

  load_balancer_type = "application"


  security_groups = [

    aws_security_group.alb_sg.id

  ]


  subnets = [

    aws_subnet.public_1.id,

    aws_subnet.public_2.id

  ]


  enable_deletion_protection = false


  tags = {

    Name = "${var.project_name}-alb"

    Compliance = "PCI-DSS"

  }

}



###############################################################
# ALB Target Group
###############################################################

resource "aws_lb_target_group" "payment_target" {


  name = "${var.project_name}-tg"



  port = 80



  protocol = "HTTP"



  vpc_id = aws_vpc.main.id



  target_type = "ip"



  health_check {


    enabled = true


    path = "/health"



    matcher = "200"



    interval = 30



    timeout = 5


  }



  tags = {


    Name = "${var.project_name}-target-group"


  }


}



###############################################################
# HTTP Listener
###############################################################

resource "aws_lb_listener" "http" {


  load_balancer_arn = aws_lb.payment_alb.arn



  port = 80



  protocol = "HTTP"



  default_action {


    type = "forward"



    target_group_arn = aws_lb_target_group.payment_target.arn


  }


}