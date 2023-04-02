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
              git clone https://github.com/julianesouza/desafiodevops.git
              cd desafiodevops
              sudo chmod +x script.sh
              ./script.sh
              EOF

  tags = {
    Name = "HelloWorld"
  }
}

output "public_ip" {
  value = aws_instance.helloworld.public_ip
}