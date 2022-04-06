output "application_lambda_name" {
  value       = aws_lambda_function.application.function_name
  description = "The name of the lambda used to run the application"
}

output "application_lambda_arn" {
  value       = aws_lambda_function.application.arn
  description = "The ARN of the lambda used to run the application"
}
