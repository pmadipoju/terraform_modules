# main.tf

provider "aws" {
  region = "ap-south-1"

}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}


module "iam" {
  source             = "./Modules/iam"
  role_name          = "lambda_role"
  policy_name        = "iam_policy_for_lambda"
  policy_description = "policy for lambda function"
}

module "lambda" {
  source               = "./Modules/lambda"
  lambda_function_name = "Lambda_func"
  lambda_role_arn      = module.iam.iam_role_arn
  lambda_handler       = "hello-python.lambda_handler"
  lambda_runtime       = "python3.8"
  lambda_zip_path      = data.archive_file.zip_the_python_code.output_path
}

module "api" {
  source = "./Modules/API"
  lambda_arn = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
}

output "terraform_aws_role_output" {
  value = module.iam.iam_role_name
}

output "terraform_aws_role_arn_output" {
  value = module.iam.iam_role_arn
}

output "terraform_logging_arn_output" {
  value = module.iam.iam_policy_arn
}


