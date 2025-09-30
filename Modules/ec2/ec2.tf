 resource "aws_instance" "wordpress" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id = var.subnet_id
    tags = {
    Name = local.tag_name
  }
  key_name = local.key_name
  user_data = file("user.sh")

  vpc_security_group_ids = [var.vpc_security_group_ids]
   associate_public_ip_address = true
}
