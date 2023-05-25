
# Create Lambda function
resource "aws_lambda_function" "warriors-billing_threshold_function" {
  function_name = "billing-threshold-function"
  runtime       = "python3.10"
  handler       = "lambda_function.lambda_handler"
  timeout       = 300

  # Specify the path to your Lambda function code
   data "archive_file" "alarm_function_code" {
    type        = "zip"
    source_dir  = "${path.module}/lambda_function"
    output_path = "${path.module}/lambda_function.zip"  
  }
   
    
  # Create IAM role for Lambda function
  role          = aws_iam_role.lambda_role.arn
}

# IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "billing-threshold-lambda-role"
 
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

# IAM policy for the Lambda function
resource "aws_iam_policy" "lambda_policy" {
  name        = "billing-threshold-lambda-policy"
  description = "Policy for billing threshold Lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:RunInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
