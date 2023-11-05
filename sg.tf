resource "aws_security_group" "alb" {
  name = "web-alb"
  description = "Allow incoming Https Conncections"

  ingress {
     from_port = 443
     to_port = 443
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-server" {
  name = "web-server-sg"
  description = "Allow incoming Https Conncections"

  ingress {
     from_port = 443
     to_port = 443
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

