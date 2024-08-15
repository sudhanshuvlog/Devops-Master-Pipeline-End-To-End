resource "aws_instance" "web" {
  depends_on = [aws_key_pair.my_key_pair, aws_security_group.webserver_sg ]
  ami   = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instanceType
  tags = {
    Name = "${var.instanceTagName}"
  }
  key_name = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  provisioner "local-exec" {
    command = "echo 'resource exectued succesfully'"
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "testkeygfg"
  public_key = file("./mykey.pub")
}

resource "aws_security_group" "webserver_sg" {
  name        = var.sg_name
  description = "Webserver Security Group Allow port 80"
  vpc_id      = data.aws_vpcs.default_vpc.ids[0]

  dynamic "ingress" {
    for_each = [80,22,8080,3000,9090]
    content { 
    description      = "---"
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "null_resource" "configureAnsibleInventory" {
triggers ={
  mytrigger = timestamp()
}
provisioner "local-exec" {
    command = "echo [prod] > inventory"
  }

}
resource "null_resource" "configureansibleinventoryIPdetails"{
triggers ={
  mytrigger = timestamp()
}
provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=mykey >> inventory"
  }
}

resource "null_resource" "destroy_resource"{
  provisioner "local-exec" {
    when = destroy
    command = "echo destroying resources.. > gfgdestroy.txt"
  }
}
