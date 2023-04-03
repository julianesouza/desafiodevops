#imagem 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


#instance 
resource "aws_instance" "helloworld" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get -y install \
              ca-certificates \
              curl \
              gnupg
              sudo mkdir -m 0755 -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
              echo \
              "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/u$  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get -y update
              sudo apt-get install -y docker-ce
              sudo apt install -y docker-compose
              sudo usermod -aG docker $USER
              git clone https://github.com/julianesouza/desafiodevops.git
              cd desafiodevops/app
              sudo docker-compose up
              EOF

  tags = {
    Name = "HelloWorld"
  }
}

output "public_ip" {
  value = aws_instance.helloworld.public_ip
}