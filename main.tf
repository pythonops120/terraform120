# Provider configuration
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
}

# Create security groups
resource "aws_security_group" "app_sg" {
  name_prefix = "app-"
  vpc_id      = aws_vpc.my_vpc.id

  // Define inbound and outbound rules as needed
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-"
  vpc_id      = aws_vpc.my_vpc.id

  // Define inbound and outbound rules as needed
}

resource "aws_security_group" "db_sg" {
  name_prefix = "db-"
  vpc_id      = aws_vpc.my_vpc.id

  // Define inbound and outbound rules as needed
}

# Launch EC2 instances
resource "aws_instance" "app_instance" {
  ami           = "ami-12345678"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.name]
}

resource "aws_instance" "web_instance" {
  ami           = "ami-12345678"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web_subnet.id
  security_groups = [aws_security_group.web_sg.name]
}

# Create RDS database instance
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  name                = "mydbinstance"
  username            = "admin"
  password            = "secretpassword"
  parameter_group_name = "default.mysql5.7"

  subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

# Create DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.db_subnet.id]
}

# Outputs
output "app_instance_ip" {
  value = aws_instance.app_instance.public_ip
}

output "web_instance_ip" {
  value = aws_instance.web_instance.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}
