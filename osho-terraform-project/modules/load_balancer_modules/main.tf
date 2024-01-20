# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_2_id]
  subnets            = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
  enable_deletion_protection = false

  tags   = {
    Name = "${var.project_name}-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.project_name}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}_alb_tg"
  }

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}


/*
resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = [ subnet_a_id, subnet_b_id, subnet_c_id]
  port             = 80
}*/

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
      target_group_arn = aws_lb_target_group.alb_target_group.arn
      type             = "forward"
    }
  }




