# print the url of the load balalncer app
output "load_balancer_dns_name" {
  value = aws_lb.alb.dns_name
}
# print the url of the webserver 1
output "webserver1_public_dns" {
    value = aws_instance.instance-1.public_dns
}
# print the url of the webserver 2
output "webserver2_public_dns" {
    value = aws_instance.instance-2.public_dns
}


