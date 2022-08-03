# Lookup route53 hosted zones
data "aws_route53_zone" "hosted_zone" {
  name = "stantestdomain.com"
  private_zone = false
}

# Create route53 cname record to map to alb dns name
resource "aws_route53_record" "my_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name = "www.project.stantestdomain.com"
  type = "CNAME"
  ttl = "100"
  records = var.alb_dns_name
}