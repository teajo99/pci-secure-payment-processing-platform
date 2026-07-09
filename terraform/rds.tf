###############################################################
# RDS Subnet Group
###############################################################

resource "aws_db_subnet_group" "payment_db_subnet_group" {


  name = "${var.project_name}-db-subnet-group"



  subnet_ids = [


    aws_subnet.private_db_1.id,

    aws_subnet.private_db_2.id


  ]



  tags = {


    Name = "${var.project_name}-db-subnet-group"


    Compliance = "PCI-DSS"


  }


}



###############################################################
# RDS Parameter Group
###############################################################

resource "aws_db_parameter_group" "postgres" {


  name = "${var.project_name}-postgres-params"



  family = "postgres16"



  parameter {


    name = "log_connections"


    value = "1"


  }



  parameter {


    name = "log_disconnections"


    value = "1"


  }



  parameter {


    name = "log_statement"


    value = "ddl"


  }



}



###############################################################
# PostgreSQL RDS Instance
###############################################################

resource "aws_db_instance" "payment_database" {


  identifier = "${var.project_name}-postgres"



  engine = "postgres"



  engine_version = "16"



  instance_class = var.db_instance_class



  allocated_storage = 20



  storage_type = "gp3"



  db_name = var.db_name



  username = var.db_username



  password = var.db_password



  db_subnet_group_name = aws_db_subnet_group.payment_db_subnet_group.name



  vpc_security_group_ids = [


    aws_security_group.rds_sg.id


  ]



  parameter_group_name = aws_db_parameter_group.postgres.name



  multi_az = true



  publicly_accessible = false



  storage_encrypted = true



  kms_key_id = aws_kms_key.payment_key.arn



  backup_retention_period = 30



  backup_window = "03:00-04:00"



  maintenance_window = "sun:04:00-sun:05:00"



  deletion_protection = true



  skip_final_snapshot = false



  final_snapshot_identifier = "${var.project_name}-final-snapshot"



  enabled_cloudwatch_logs_exports = [


    "postgresql"


  ]



  tags = {


    Name = "${var.project_name}-database"


    Compliance = "PCI-DSS"


  }


}
