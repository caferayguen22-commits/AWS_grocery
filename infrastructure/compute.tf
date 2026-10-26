# Aktuelles Amazon Linux 2023 aus dem offiziellen AWS-Parameter (statt einer fest eingetragenen AMI-ID)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  # Festplatte: klein und verschlüsselt
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  # IMDSv2 erzwingen (sicherer Zugriff auf Instanz-Metadaten)
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "grocerymate-ec2"
  }
}
