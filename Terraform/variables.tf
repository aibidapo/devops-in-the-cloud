variable "vpc_cidr" {
  type        = string
  description = "cidr address of the vpc"
  default     = "10.123.0.0/16"
}

variable "cloud9_ip" {
  type        = string
  default     = "52.20.20.74/32"
  description = "This is the elastic IP address of the cloud9 instance"
  # Note that your public address might change from time to time. 
  # You can make this the public IP of your pc used to access the cloud.
}
variable "access_ip" {
  type    = string
  default = "0.0.0.0/0"

}

variable "main_instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "main_vol_size" {
  type    = number
  default = 8
}

variable "main_instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type    = string
  default = "~/.ssh/ai-devops-prod-key"
  # default = "value" <-- Defined in terraform.tfvars
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/ai-devops-prod-key.pub"
  # <-- Defined in terraform.tfvars
}