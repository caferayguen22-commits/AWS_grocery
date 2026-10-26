output "ec2_public_ip" {
  description = "Öffentliche IP der EC2-Instanz"
  value       = aws_instance.app.public_ip
}

output "alb_dns_name" {
  description = "DNS-Name des Load Balancers (im Browser: http://<dns-name>)"
  value       = aws_lb.app.dns_name
}

output "ssh_command" {
  description = "Fertiger SSH-Befehl"
  value       = "ssh -i ~/.ssh/grocerymate-key.pem ec2-user@${aws_instance.app.public_ip}"
}
