variable "AWS_REGION" {
  default = "us-east-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  #default = "~/Downloads/uat-ssh-key.pem"
  default = "~/Enter/your/key/path/here"
}
variable "PATH_TO_PUBLIC_KEY" {
  #default = "~/Downloads/uat-ssh-key.pub"
  default = "~/Enter/your/key/path/here"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}
