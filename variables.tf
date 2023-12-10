variable "region" {
  type        = string
  default     = "us-west-1"
  description = "AWS region"
}

variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "bucket_name" {
  type        = string
  description = "AWS Secret Key"
}

variable "amis" {
  type = map(any)
  default = {
    # ap-east-1 = "ami-08fb8c56472e9ef3a"
    us-west-1 = "ami-06e4ca05d431835e9"
  }
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

variable "public_key" {
  type        = string
  default     = "id_rsa.pub"
  description = "SSH public key"
}

variable "private_key" {
  type        = string
  default     = "id_rsa"
  description = "SSH private key"
}

# variable "security_group" {
#   type        = string
#   description = "Security Group ID"
# }

