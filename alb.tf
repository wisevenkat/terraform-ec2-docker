# target group
resource "aws_lb_target_group" "target-group" {
  name        = "web-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "443"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# creating ALB
resource "aws_lb" "application-lb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.subnet.ids
  security_groups    = [aws_security_group.alb.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "nit-alb"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 443
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

#attach ec2 to alb target group
resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.web-server)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.web-server[count.index].id
}


# Request and validate an SSL certificate from AWS Certificate Manager (ACM)
resource "aws_acm_certificate" "my-certificate" {
  domain_name       = var.dns_domain
  validation_method = "DNS"

  tags = {
    Name = "example.com SSL certificate"
  }
}

# Associate the SSL certificate with the ALB listener
resource "aws_lb_listener_certificate" "my-certificate" {
  listener_arn = aws_lb_listener.alb-listener.arn
  certificate_arn = aws_acm_certificate.my-certificate.arn
}
