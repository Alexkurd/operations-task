# Make lambda archive
data "archive_file" "lambda_import" {
  type = "zip"

  source_dir  = "${path.module}/assets/lambda-import"
  output_path = "${path.module}/dist/lambda-import.zip"
}

# Upload lambda archive to S3
resource "aws_s3_object" "lambda_import" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambda-import.zip"
  source = data.archive_file.lambda_import.output_path

  etag = filemd5(data.archive_file.lambda_import.output_path)
}

# Main function
resource "aws_lambda_function" "import" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_import.key

  runtime = "python3.8"
  handler = "import.handler"

  source_code_hash = data.archive_file.lambda_import.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

# IAM role. TODO Add RDS access rights
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}