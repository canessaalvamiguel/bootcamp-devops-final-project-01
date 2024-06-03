variable "project_id" {
  type = string
  default = "level-ward-423317-j3"
}

variable "cluster_name" {
  type = string
  default = "lab-cluster"
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "zone" {
  type    = string
  default = "us-west1-c"
}

variable "repository_name_frontend" {
  type    = string
  default = "avatares-devops-frontend"
}

variable "repository_name_backend" {
  type    = string
  default = "avatares-devops-backend"
}