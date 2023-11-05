resource "aws_key_pair" "key_pair" {
  key_name = "mykeypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

#Create ec2 instance based on count
resource "aws_instance" "web-server" {
  ami = "ami-00448a337adc93c05"
  instance_type = "t2.micro"
  count = var.instance_count
  key_name= aws_key_pair.key_pair.key_name
  security_groups = ["${aws_security_group.web-server.name}"]
  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              systemctl enable docker
              systemctl start docker
              sudo chown $USER /var/run/docker.sock
              docker run -p 443:80 -d nginxdemos/hello
              EOF
  tags = {
    name ="instance_alb-${count.index}"
  }
}