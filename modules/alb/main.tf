resource "aws_lb" "alb" {
    name = "project-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = var.alb_sg
    subnets = var.alb_subnets

    tags = {
        Name = "prject-alb"
    }
  
}

#adding port80 to listener to alb
resource "aws_lb_listener" "httpd_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "redirect"

      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }

}

#data call for ssl certificate
data "aws_acm_certificate" "issues" {
    domain = "www.project.stantestdomain.com"
    statuses = ["ISSUED"]
  
}

#adding port 443 listener to alb
resource "aws_alb_listener" "https_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = data.aws_acm_certificate.issues.arn

    default_action {
        type = "forward"
        target_group_arn = var.target_group_arn
    }  
    depends_on = [
      aws_lb.alb
    ]
}
