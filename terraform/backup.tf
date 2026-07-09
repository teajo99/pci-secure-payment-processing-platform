###############################################################
# AWS Backup Vault
###############################################################

resource "aws_backup_vault" "payment_backup_vault" {

  name = "${var.project_name}-backup-vault"


  kms_key_arn = aws_kms_key.payment_key.arn


  tags = {

    Name = "${var.project_name}-backup-vault"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# AWS Backup Plan
###############################################################

resource "aws_backup_plan" "payment_backup_plan" {


  name = "${var.project_name}-backup-plan"



  rule {


    rule_name = "daily-backup"


    target_vault_name = aws_backup_vault.payment_backup_vault.name



    schedule = "cron(0 2 * * ? *)"



    lifecycle {


      cold_storage_after = 30


      delete_after = 365


    }


  }


}



###############################################################
# AWS Backup Selection Role
###############################################################

resource "aws_iam_role" "backup_selection_role" {


  name = "${var.project_name}-backup-selection-role"



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
# AWS Backup Permissions
###############################################################

resource "aws_iam_role_policy_attachment" "backup_selection_policy" {


  role = aws_iam_role.backup_selection_role.name



  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"


}



###############################################################
# Backup Selection
###############################################################

resource "aws_backup_selection" "rds_backup_selection" {


  name = "${var.project_name}-rds-selection"



  plan_id = aws_backup_plan.payment_backup_plan.id



  iam_role_arn = aws_iam_role.backup_selection_role.arn



  resources = [


    aws_db_instance.payment_database.arn


  ]


}

