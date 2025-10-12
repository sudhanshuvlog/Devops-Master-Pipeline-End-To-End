resource "aws_instance" "web" {
  depends_on = [aws_security_group.webserver_sg]
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instanceType
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  count = var.instance_count

  tags = {
    Name = "${var.instanceTagName}-${count.index}"
  }

  provisioner "local-exec" {
    command = "echo 'instance ${self.id} created'"
  }
}



resource "aws_security_group" "webserver_sg" {
  name        = var.sg_name
  description = "Webserver Security Group for Kubernetes nodes"
  vpc_id      = data.aws_vpcs.default_vpc.ids[0]

  # Allow explicit ports only (keeps SSH + k8s ports + nodeport range)
  dynamic "ingress" {
    for_each = toset(var.allowedPort)
    content {
      description = "managed"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress { #Allowing all traffic within the SG (for k8s node communication) - I will remove this in upcoming changes
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # NodePort range already included in allowedPort; egress is open by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "configureAnsibleInventory" {
  # Re-run on changes to instance list
  triggers = {
    ips = join(",", aws_instance.web[*].public_ip)
  }

  # Ensure inventory is generated only after instances are created and their public IPs are known
  depends_on = [aws_instance.web]

    provisioner "local-exec" {
    command = <<EOT
cat > inventory <<INV
[k8s-master]
${aws_instance.web[0].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${path.module}/../playbooks/gfg37ansible.pem

[k8s-workers]
${join("\n", [for ip in aws_instance.web[*].public_ip : "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=${path.module}/../playbooks/gfg37ansible.pem" if ip != aws_instance.web[0].public_ip])}
INV
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "destroy_resource" {
  provisioner "local-exec" {
    when    = destroy
    command = "echo destroying resources.. > gfgdestroy.txt"
  }
}
