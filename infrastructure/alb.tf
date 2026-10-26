# Application Load Balancer: einziger öffentlicher Einstieg, steht in BEIDEN öffentlichen Subnetzen (2 AZs)
resource "aws_lb" "app" {
  name               = "grocerymate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name = "grocerymate-alb"
  }
}

# Target Group: die "Zielliste" des Load Balancers (hier: die EC2 auf Port 5050)
resource "aws_lb_target_group" "app" {
  name     = "grocerymate-tg"
  port     = 5050
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Health Check: der Load Balancer fragt regelmäßig /health der App ab
  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "grocerymate-tg"
  }
}

# Die EC2-Instanz in die Target Group eintragen
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = 5050
}

# Listener: Anfragen auf Port 80 werden an die Target Group weitergeleitet
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
