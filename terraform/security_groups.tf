###############################################################
# Security Group - Application Load Balancer
###############################################################

resource "aws_security_group" "alb_sg" {

  name        = "${var.project_name}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {

    description = "HTTPS"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  # Optional: Redirect HTTP to HTTPS
  ingress {

    description = "HTTP Redirect"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-alb-sg"

  }

}

###############################################################
# Security Group - ECS Fargate
###############################################################

resource "aws_security_group" "ecs_sg" {

  name = "${var.project_name}-ecs-sg"

  description = "Security Group for ECS"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "Traffic from ALB"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [

      aws_security_group.alb_sg.id

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

  tags = {

    Name = "${var.project_name}-ecs-sg"

  }

}

###############################################################
# Security Group - PostgreSQL Database
###############################################################

resource "aws_security_group" "rds_sg" {

  name = "${var.project_name}-rds-sg"

  description = "Security Group for PostgreSQL"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "PostgreSQL"

    from_port = 5432

    to_port = 5432

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

  tags = {

    Name = "${var.project_name}-rds-sg"

  }

}

###############################################################
# Security Group - VPC Interface Endpoints
###############################################################

resource "aws_security_group" "vpce_sg" {

  name = "${var.project_name}-vpce-sg"

  description = "Security Group for VPC Endpoints"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "HTTPS from VPC"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [

      var.vpc_cidr

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

  tags = {

    Name = "${var.project_name}-vpce-sg"

  }

}
