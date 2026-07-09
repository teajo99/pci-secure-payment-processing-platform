###############################################################
# Database Credentials Secret
###############################################################

resource "aws_secretsmanager_secret" "database_credentials" {

  name = "${var.project_name}/database/credentials"

  description = "PCI payment database credentials"

  kms_key_id = aws_kms_key.payment_key.id


  recovery_window_in_days = 30


  tags = {

    Name = "${var.project_name}-database-secret"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# Database Credentials Secret Version
###############################################################

resource "aws_secretsmanager_secret_version" "database_credentials" {

  secret_id = aws_secretsmanager_secret.database_credentials.id


  secret_string = jsonencode({

    username = var.db_username

    password = var.db_password

    database = var.db_name

  })

}


###############################################################
# Application Secret
###############################################################

resource "aws_secretsmanager_secret" "application_secret" {

  name = "${var.project_name}/application/config"

  description = "Application configuration secret"

  kms_key_id = aws_kms_key.payment_key.id


  recovery_window_in_days = 30


  tags = {

    Name = "${var.project_name}-application-secret"

    Compliance = "PCI-DSS"

  }

}


###############################################################
# Application Secret Version
###############################################################

resource "aws_secretsmanager_secret_version" "application_secret" {

  secret_id = aws_secretsmanager_secret.application_secret.id


  secret_string = jsonencode({

    environment = var.environment

    application = "payment-api"

  })

}
