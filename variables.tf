variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "backend_bucket" {
  type        = string
  description = "S3 bucket for backend"
}

variable "backend_dynamodb" {
  type        = string
  description = "DynamoDB table for backend"
}
