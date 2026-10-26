# Subnetzgruppe: sagt RDS, in welchen (privaten!) Subnetzen die Datenbank liegen darf
resource "aws_db_subnet_group" "main" {
  name       = "grocerymate-db-subnets"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "grocerymate-db-subnets"
  }
}

# PostgreSQL-Datenbank: privat, verschlüsselt, klein (laut Kursregeln db.t3.micro)
resource "aws_db_instance" "main" {
  identifier     = "grocerymate-db-tf"
  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "grocerymate_db"
  username = "postgres"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "grocerymate-db-tf"
  }
}
