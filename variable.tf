variable "AWS_REGION" {
  default = "ap-south-2"
}
variable "VPC_NAME" {
  default = "Devops-vpc3"
}

variable "Zone1" {
  default = "ap-south-2a"
}

variable "Zone2" {
  default = "ap-south-2b"
}

variable "Zone3" {
  default = "ap-south-2c"
}

variable "Vpc_CIDR" {
  default = "172.21.0.0/16"
}


variable "Pub_Sub_1" {
  default = "172.21.1.0/24"
}

variable "Pub_Sub_2" {
  default = "172.21.2.0/24"
}

variable "Pub_Sub_3" {
  default = "172.21.3.0/24"
}

variable "Priv_Sub_1" {
  default = "172.21.4.0/24"
}

variable "Priv_Sub_2" {
  default = "172.21.5.0/24"
}

variable "Priv_Sub_3" {
  default = "172.21.6.0/24"
}

variable "PROJECT" {
  default = "Devops-project2"
}

variable "PUBLIC_KEY_PATH" {
  default = "id_rsa.pub"
}
