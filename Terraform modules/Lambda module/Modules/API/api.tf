resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "lambdaAPI"
  description = "This is my API for demonstration purposes"
}


resource "aws_api_gateway_resource" "lambda_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "lambdaAPIResource"
}

resource "aws_api_gateway_method" "lambda_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.lambda_api_resource.id
  http_method             = aws_api_gateway_method.lambda_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn
}

variable "lambda_arn" {
  default = ""
  
}

/*module "aws_lambda_module" {
  source = "../lambda"
}*/

/*resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id               = aws_apigatewayv2_api.lambda-api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  #integration_uri      = module.aws_lambda_module.output.lambda_function_arn
  integration_uri = var.lambda_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}



resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda-api.id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
*/
variable "myregion" {
  default = "ap-south-1"
}

variable "accountId" {
  default = ""
}

resource "aws_lambda_permission" "api-gw-permission" {
  statement_id  = "AllowExcutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.lambda_api.id}/*/${aws_api_gateway_method.lambda_api_method.http_method}${aws_api_gateway_resource.lambda_api_resource.path}"
}



variable "lambda_function_name" {
  default = ""
  
}




