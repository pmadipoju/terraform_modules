# modules/lambda/main.tf

variable "lambda_function_name" {
  description = "Name of the lambda function"
  type        = string
  
}

variable "lambda_role_arn" {
  description = "ARN of the lambda IAM role"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for the lambda function"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the lambda function ZIP file"
  type        = string
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = ".../python/"
  output_path = ".../python/hello-python.zip"
}

locals {
    source_code_hash = filebase64sha256(data.archive_file.zip_the_python_code.output_path)
  }

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = var.lambda_zip_path
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  source_code_hash = local.source_code_hash
  
}

output "lambda_function_arn" {
  value = aws_lambda_function.terraform_lambda_func.invoke_arn
  
}

output "lambda_function_name" {
  value = aws_lambda_function.terraform_lambda_func.arn
}


