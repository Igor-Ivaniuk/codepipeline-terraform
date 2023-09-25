variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}
