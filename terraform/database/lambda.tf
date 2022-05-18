resource "aws_lambda_function" "migration" {
  filename         = var.zip_filename
  source_code_hash = filebase64sha256(var.zip_filename)
  function_name    = local.migration_lambda_name
  role             = aws_iam_role.migration_lambda.arn
  handler          = var.migration_handler
  runtime          = var.migration_runtime
  timeout          = 300
  tags             = local.migration_lambda_tags

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      akeyless_access_id              = akeyless_auth_method_aws_iam.migration.access_id
      akeyless_mysql_dynamic_producer = akeyless_producer_mysql.migration.name
      akeyless_api_host               = "https://api.akeyless.io"
      db_database                     = aws_rds_cluster.database.database_name
      db_host                         = aws_rds_cluster.database.endpoint
    }
  }
}

resource "aws_iam_role" "migration_lambda" {
  name               = local.migration_lambda_name
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

  tags = local.migration_lambda_tags
}

resource "aws_iam_role_policy_attachment" "allow_lambda" {
  role       = aws_iam_role.migration_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "networking" {
  name   = "${local.migration_lambda_name}-networking"
  role   = aws_iam_role.migration_lambda.id
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
  name   = "${local.migration_lambda_name}-cloudwatch"
  role   = aws_iam_role.migration_lambda.id
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
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.migration_lambda_name}*:*"
            ]
        }
    ]
}
EOF
}
