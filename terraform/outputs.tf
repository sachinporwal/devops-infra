output "app_ip" {
  value = module.ec2.app_public_ip
}


output "alb_url" {
  value = module.alb.alb_dns
}
