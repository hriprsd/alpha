resource "aws_instance" "Instance1" {
  #ami = "ami-0c1a7f89451184c8b"
  ami = var.ami
  #instance_type = "t2.micro"
  instance_type = var.instance_type
  tags = {
    Name = "Ubuntu-AMIInstance"
  }
}
resource "aws_instance" "Instance2" {
  #ami = "ami-04db49c0fb2215364"
  ami = var.ami
  #instance_type = "m4.large"
  instance_type = var.instance_type
  tags = {
    Name = "AmazonLinux-Instance"
  }
}
