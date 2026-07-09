###############################################################
# VPC
###############################################################

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }

}

###############################################################
# Internet Gateway
###############################################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }

}

###############################################################
# Availability Zones
###############################################################

locals {

  az1 = data.aws_availability_zones.available.names[0]

  az2 = data.aws_availability_zones.available.names[1]

}

###############################################################
# Public Subnet 1
###############################################################

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = local.az1

  map_public_ip_on_launch = true

  tags = {

    Name = "${var.project_name}-public-1"

    Tier = "Public"

  }

}

###############################################################
# Public Subnet 2
###############################################################

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = local.az2

  map_public_ip_on_launch = true

  tags = {

    Name = "${var.project_name}-public-2"

    Tier = "Public"

  }

}

###############################################################
# Private App Subnet 1
###############################################################

resource "aws_subnet" "private_app_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_app_subnet_1_cidr

  availability_zone = local.az1

  tags = {

    Name = "${var.project_name}-private-app-1"

    Tier = "Application"

  }

}

###############################################################
# Private App Subnet 2
###############################################################

resource "aws_subnet" "private_app_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_app_subnet_2_cidr

  availability_zone = local.az2

  tags = {

    Name = "${var.project_name}-private-app-2"

    Tier = "Application"

  }

}

###############################################################
# Private Database Subnet 1
###############################################################

resource "aws_subnet" "private_db_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_db_subnet_1_cidr

  availability_zone = local.az1

  tags = {

    Name = "${var.project_name}-private-db-1"

    Tier = "Database"

  }

}

###############################################################
# Private Database Subnet 2
###############################################################

resource "aws_subnet" "private_db_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_db_subnet_2_cidr

  availability_zone = local.az2

  tags = {

    Name = "${var.project_name}-private-db-2"

    Tier = "Database"

  }

}

###############################################################
# Elastic IP
###############################################################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {

    Name = "${var.project_name}-nat-eip"

  }

}

###############################################################
# NAT Gateway
###############################################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  depends_on = [

    aws_internet_gateway.igw

  ]

  tags = {

    Name = "${var.project_name}-nat"

  }

}

###############################################################
# Public Route Table
###############################################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {

    Name = "${var.project_name}-public-rt"

  }

}

###############################################################
# Private Route Table
###############################################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {

    Name = "${var.project_name}-private-rt"

  }

}

###############################################################
# Public Route Associations
###############################################################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public_1.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public_2.id

  route_table_id = aws_route_table.public.id

}

###############################################################
# Private Application Route Associations
###############################################################

resource "aws_route_table_association" "private_app1" {

  subnet_id = aws_subnet.private_app_1.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_app2" {

  subnet_id = aws_subnet.private_app_2.id

  route_table_id = aws_route_table.private.id

}

###############################################################
# Private Database Route Associations
###############################################################

resource "aws_route_table_association" "private_db1" {

  subnet_id = aws_subnet.private_db_1.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_db2" {

  subnet_id = aws_subnet.private_db_2.id

  route_table_id = aws_route_table.private.id

}
