# S3-Bucket für die Avatar-Bilder der GroceryMate-App (privat, in derselben Region wie die EC2 = eu-north-1)
resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-cafer"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}

# Privat: jeder öffentliche Zugriff wird blockiert (Pflicht laut Leitfaden)
resource "aws_s3_bucket_public_access_block" "avatars" {
  bucket = aws_s3_bucket.avatars.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versionierung (empfohlen): alte Versionen bleiben erhalten, gelöschte Dateien lassen sich zurückholen
resource "aws_s3_bucket_versioning" "avatars" {
  bucket = aws_s3_bucket.avatars.id

  versioning_configuration {
    status = "Enabled"
  }
}
