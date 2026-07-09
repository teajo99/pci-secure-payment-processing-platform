###############################################################
# ECS Cluster
###############################################################

resource "aws_ecs_cluster" "payment_cluster" {


  name = "${var.project_name}-cluster"



  setting {

    name = "containerInsights"

    value = "enabled"

  }



  tags = {


    Name = "${var.project_name}-ecs-cluster"


    Compliance = "PCI-DSS"


  }


}



###############################################################
# ECS Task Execution Role
###############################################################

resource "aws_iam_role" "ecs_execution_role_new" {


  name = "${var.project_name}-ecs-execution-role-new"



  assume_role_policy = jsonencode({


    Version = "2012-10-17"



    Statement = [


      {


        Effect = "Allow"



        Principal = {


          Service = "ecs-tasks.amazonaws.com"


        }



        Action = "sts:AssumeRole"


      }


    ]


  })


}



###############################################################
# ECS Execution Policy
###############################################################

resource "aws_iam_role_policy_attachment" "ecs_execution_policy_new" {


  role = aws_iam_role.ecs_execution_role_new.name



  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"


}



###############################################################
# ECS Task Role
###############################################################

resource "aws_iam_role" "ecs_application_role" {


  name = "${var.project_name}-application-role"



  assume_role_policy = jsonencode({


    Version = "2012-10-17"



    Statement = [


      {


        Effect = "Allow"



        Principal = {


          Service = "ecs-tasks.amazonaws.com"


        }



        Action = "sts:AssumeRole"


      }


    ]


  })


}



###############################################################
# ECS Application Permissions
###############################################################

resource "aws_iam_role_policy" "ecs_application_policy" {


  name = "${var.project_name}-application-policy"



  role = aws_iam_role.ecs_application_role.id



  policy = jsonencode({


    Version = "2012-10-17"



    Statement = [


      {


        Effect = "Allow"



        Action = [


          "secretsmanager:GetSecretValue",

          "kms:Decrypt"


        ]



        Resource = "*"


      }


    ]


  })


}



###############################################################
# ECS Task Definition
###############################################################

resource "aws_ecs_task_definition" "payment_api" {


  family = "${var.project_name}-payment-api"



  requires_compatibilities = [


    "FARGATE"


  ]



  network_mode = "awsvpc"



  cpu = "512"



  memory = "1024"



  execution_role_arn = aws_iam_role.ecs_execution_role_new.arn



  task_role_arn = aws_iam_role.ecs_application_role.arn



  container_definitions = jsonencode([


    {


      name = "payment-api"



      image = var.container_image



      essential = true



      portMappings = [


        {


          containerPort = 80


          protocol = "tcp"


        }


      ]



      secrets = [


        {


          name = "DB_USERNAME"


          valueFrom = aws_secretsmanager_secret.database_credentials.arn


        },


        {


          name = "DB_PASSWORD"


          valueFrom = aws_secretsmanager_secret.database_credentials.arn


        }


      ]



      logConfiguration = {


        logDriver = "awslogs"



        options = {


          awslogs-group = aws_cloudwatch_log_group.ecs_payment_logs.name


          awslogs-region = var.aws_region


          awslogs-stream-prefix = "payment"


        }


      }


    }


  ])



}



###############################################################
# ECS Service
###############################################################

resource "aws_ecs_service" "payment_service" {


  name = "${var.project_name}-service"



  cluster = aws_ecs_cluster.payment_cluster.id



  task_definition = aws_ecs_task_definition.payment_api.arn



  desired_count = 2



  launch_type = "FARGATE"



  deployment_minimum_healthy_percent = 50



  deployment_maximum_percent = 200



  network_configuration {


    subnets = [


      aws_subnet.private_app_1.id,


      aws_subnet.private_app_2.id


    ]



    security_groups = [


      aws_security_group.ecs_sg.id


    ]



    assign_public_ip = false


  }



  load_balancer {


    target_group_arn = aws_lb_target_group.payment_target.arn



    container_name = "payment-api"



    container_port = 80


  }



  depends_on = [


    aws_lb_listener.http


  ]



  tags = {


    Name = "${var.project_name}-ecs-service"


    Compliance = "PCI-DSS"


  }


}
