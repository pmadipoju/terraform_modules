# modules/iam/main.tf

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default = "lambda_role"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default = "lambda_role_policy"
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default = "Policy for lambda function"
}


resource "aws_iam_role" "lambda_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = var.policy_name
  path        = "/"
  description = var.policy_description

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

output "iam_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "iam_policy_arn" {
  value = aws_iam_policy.iam_policy_for_lambda.arn
}
