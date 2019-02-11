#Application load balancer
resource "aws_lb" "uat-FrontendLB" {
  name               = "uat-FrontendLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.uat-frontend-sg.id}"]
  subnets            = ["${aws_subnet.uat-public-1a.id}", "${aws_subnet.uat-public-1c.id}"]

  tags = {
    Environment = "uat"
  }
}

# aws_lb_target_group
resource "aws_lb_target_group" "uat-tg" {
  name        = "uat-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.main.id}"
  health_check {
    healthy_threshold   = 2
    interval            = 5
    path                = "/companyNews/index.jsp"
    timeout             = 4
    unhealthy_threshold = 4
  }
}

#aws_lb_listener
resource "aws_lb_listener" "uat-frontend-listener" {
  load_balancer_arn = "${aws_lb.uat-FrontendLB.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.uat-tg.arn}"
  }
}

resource "aws_lb_listener" "uat-frontend-secure-listener" {
  load_balancer_arn = "${aws_lb.uat-FrontendLB.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:508112170859:certificate/cfd72e12-8763-4296-a65f-edc6ad2f0fc8"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.uat-tg.arn}"
  }
}

#aws_lb_listener_rule
resource "aws_lb_listener_rule" "static" {
  listener_arn = "${aws_lb_listener.uat-frontend-listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.uat-tg.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["/companyNews/index.jsp"]
  }
}
