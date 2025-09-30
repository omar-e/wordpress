locals {
  ami="ami-046c2381f11878233"
   instance_type = "t2.micro"
  tag_name = "word"
  key_name = "trial"
}
variable "subnet_id" {
  description = "subnet id "
  type = string
  
}
variable "vpc_security_group_ids" {
  type = string
  
}