# --- Load Balancer: darf aus dem Internet erreicht werden (HTTP) ---
resource "aws_security_group" "alb" {
  name        = "grocerymate-alb-tf-sg"
  description = "Load Balancer: HTTP aus dem Internet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "grocerymate-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP aus dem Internet"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  description       = "Alles ausgehend erlaubt"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# --- EC2: App-Port NUR vom Load Balancer, SSH nur von deiner IP ---
resource "aws_security_group" "ec2" {
  name        = "grocerymate-ec2-tf-sg"
  description = "EC2: App-Port nur vom Load Balancer, SSH nur von Cafer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "grocerymate-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_app_from_alb" {
  security_group_id            = aws_security_group.ec2.id
  description                  = "App-Port 5050 nur vom Load Balancer (Security Group als Quelle)"
  ip_protocol                  = "tcp"
  from_port                    = 5050
  to_port                      = 5050
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2.id
  description       = "SSH nur von deiner IP"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.ssh_allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_out" {
  security_group_id = aws_security_group.ec2.id
  description       = "Alles ausgehend erlaubt (Updates, Docker-Images)"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# --- RDS: Datenbank-Port NUR von der EC2 (kein Internet) ---
resource "aws_security_group" "rds" {
  name        = "grocerymate-rds-tf-sg"
  description = "RDS: PostgreSQL nur von der EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "grocerymate-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ec2" {
  security_group_id            = aws_security_group.rds.id
  description                  = "PostgreSQL 5432 nur von der EC2-Security-Group"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.ec2.id
}
