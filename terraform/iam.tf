###############################################################
# ECS Task Execution Role
###############################################################

resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.project_name}-ecs-execution-role"

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
# Attach ECS Execution Policy
###############################################################

resource "aws_iam_role_policy_attachment" "ecs_execution" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

###############################################################
# ECS Task Role
###############################################################

resource "aws_iam_role" "ecs_task_role" {

  name = "${var.project_name}-ecs-task-role"

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
# ECS Task Custom Policy
###############################################################

resource "aws_iam_policy" "ecs_task_policy" {

  name = "${var.project_name}-ecs-policy"

  description = "Least privilege policy for payment application"

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

      },

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogStream",

          "logs:PutLogEvents"

        ]

        Resource = "*"

      }

    ]

  })

}

###############################################################
# Attach ECS Custom Policy
###############################################################

resource "aws_iam_role_policy_attachment" "ecs_task_attach" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.ecs_task_policy.arn

}

###############################################################
# AWS Config Role
###############################################################

resource "aws_iam_role" "config_role" {

  name = "${var.project_name}-config-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "config.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

###############################################################
# AWS Config Managed Policy
###############################################################

resource "aws_iam_role_policy_attachment" "config_policy" {

  role = aws_iam_role.config_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"

}

###############################################################
# AWS Backup Role
###############################################################

resource "aws_iam_role" "backup_role" {

  name = "${var.project_name}-backup-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "backup.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

###############################################################
# AWS Backup Managed Policy
###############################################################

resource "aws_iam_role_policy_attachment" "backup_policy" {

  role = aws_iam_role.backup_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"

}

###############################################################
# AWS Backup Restore Policy
###############################################################

resource "aws_iam_role_policy_attachment" "backup_restore" {

  role = aws_iam_role.backup_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"

}

###############################################################
# CloudWatch Logs Policy
###############################################################

resource "aws_iam_policy" "cloudwatch_logs" {

  name = "${var.project_name}-cloudwatch-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogGroup",

          "logs:CreateLogStream",

          "logs:PutLogEvents"

        ]

        Resource = "*"

      }

    ]

  })

}

###############################################################
# Attach CloudWatch Policy
###############################################################

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.cloudwatch_logs.arn

}
