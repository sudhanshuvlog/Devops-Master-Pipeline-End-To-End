data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["RHEL-9.4.0_HVM-2024*-x86_64-82-Hourly2-GP3"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpcs" "default_vpc" {
}
 
