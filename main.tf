resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
  
    name = "terra-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main-pub"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Main-priv"
  }
}
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "private-rt"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-route.id
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-route.id
}




resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
 ingress {
  description = "Allow Http"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}
ingress {
  description = "Allow ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}
ingress {
  description = "Allow wordpres"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
/*resource "aws_security_group" "private_rds" {
  name        = "permit"
  description = "allow ecs to connect to ec2"
  vpc_id      = aws_vpc.main.id


  tags = {
    Name = "private-rds"
  }
  ingress {
  description = "Allow rds"
  from_port         = 3305
  to_port           = 3305
  protocol          = "tcp"
  security_groups = []


  }
}
*/

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}



/*resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "omar"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}*/

/*resource "aws_instance" "wordpress" {
  ami           = "ami-046c2381f11878233"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
    tags = {
    Name = "Hello World"
  }
  key_name = "trial"
  user_data = file("user.sh")

  vpc_security_group_ids = [aws_security_group.allow_tls.id]
   associate_public_ip_address = true
}


output "instance" {
  value = aws_instance.wordpress.public_ip
} 
/*data "aws_key_pair" "example" {
  key_name           = "trial.pem"
  include_public_key = true

  filter {
    name   = "tag:Component"
    values = ["web"]
  }
}*/
module "ec2" {
  source = "./Modules/ec2"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = aws_security_group.allow_tls.id
}
/*resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}
*/

/*module "db" {
  source = "./Modules/db"
  private-subnet = aws_db_subnet_group.rds_subnet_group.id
  security_groups = aws_security_group.private_rds.id
  
}
*/

output "public"{
  value = aws_subnet.public.id
}