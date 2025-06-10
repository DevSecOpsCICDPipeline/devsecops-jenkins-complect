variable "aws_region" {
  description = "AWS region to use for resources."
  type        = string
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources."
}

variable "environment" {
  type        = string
  description = "Environment for deployment"
}

variable "instance_tye" {
  type = string
}
variable "key_name" {
  type = string
}