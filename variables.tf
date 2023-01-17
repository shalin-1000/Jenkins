variable "availability_zones" {
  type = list(string)

}

variable "amis" {
  type = map(any)
  default = {
    "ap-south-1" : "ami-0f69bc5520884278e"
  }
}

variable "region" {
  type = string

}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string

}