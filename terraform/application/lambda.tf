resource "aws_lambda_function" "application" {
  filename         = var.zip_filename
  source_code_hash = filebase64sha256(var.zip_filename)
  function_name    = local.name
  role             = aws_iam_role.application_lambda.arn
  handler          = var.application_handler
  runtime          = var.application_runtime
  timeout          = 300
  tags             = local.tags

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      akeyless_access_id              = akeyless_auth_method_aws_iam.application.access_id
      akeyless_mysql_dynamic_producer = var.akeyless_database_producer_path
      akeyless_api_host               = var.akeyless_api_host
      db_database                     = var.database_name
      db_host                         = var.database_host
    }
  }
}

resource "aws_iam_role" "application_lambda" {
  name               = local.name
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

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "allow_lambda" {
  role       = aws_iam_role.application_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "networking" {
  name   = "${local.name}-networking"
  role   = aws_iam_role.application_lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "cloud-watch" {
  name   = "${local.name}-cloudwatch"
  role   = aws_iam_role.application_lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.name}*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_lb_target_group_attachment" "application" {
  target_group_arn = aws_lb_target_group.application.arn
  target_id        = aws_lambda_function.application.arn
  depends_on       = [aws_lambda_permission.allow_from_lb]
}

resource "aws_lambda_permission" "allow_from_lb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.application.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
}
