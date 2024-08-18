resource "aws_instance" "web" {
  depends_on = [aws_key_pair.my_key_pair, aws_security_group.webserver_sg]
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instanceType
  tags = {
    Name = "${var.instanceTagName}"
  }
  key_name = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = ["sg-0fc30dede114a834f"]
  count = 2
  provisioner "local-exec" {
    command = "echo 'resource executed successfully'"
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
    for_each = var.allowedPort
    content {
      description = "---"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "configureAnsibleInventory" {
  triggers = {
    mytrigger = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      echo "[k8s-master]" > inventory
      echo "${aws_instance.web.0.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=mykey" >> inventory
      echo "[k8s-workers]" >> inventory
      for ip in ${join(" ", aws_instance.web[*].public_ip)}; do
        if [ "$ip" != "${aws_instance.web.0.public_ip}" ]; then
          echo "$ip ansible_user=ec2-user ansible_ssh_private_key_file=mykey" >> inventory
        fi
      done
    EOT
  }
}

resource "null_resource" "destroy_resource" {
  provisioner "local-exec" {
    when    = destroy
    command = "echo destroying resources.. > gfgdestroy.txt"
  }
}
