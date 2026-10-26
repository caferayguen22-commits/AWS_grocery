variable "instance_type" {
  description = "EC2-Instanztyp (laut Kurs nur t2/t3 micro oder small erlaubt)"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Nur t2.micro, t2.small, t3.micro oder t3.small sind laut Kursregeln erlaubt."
  }
}

variable "key_name" {
  description = "Name des bestehenden EC2-Key-Pairs für SSH"
  type        = string
  default     = "grocerymate-key"
}

variable "db_password" {
  description = "Master-Passwort der Datenbank (wird in terraform.tfvars gesetzt, nie committen)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Das Passwort muss mindestens 8 Zeichen lang sein."
  }
}

variable "ssh_allowed_cidr" {
  description = "Deine öffentliche IP als /32 (nur von dort ist SSH erlaubt). Wird in terraform.tfvars gesetzt, nicht committet."
  type        = string
}
