variable "subnet_id" {}
variable "jenkins_ip" {}
variable "key_name" {}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = data.aws_subnet.selected.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.jenkins_ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "app" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.small"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = var.key_name

  tags = {
    Name = "microservice-app"
  }
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}

