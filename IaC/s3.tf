resource "aws_s3_bucket" "main_bucket" {
  bucket = "your-bucket-name"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.import.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.main_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.main_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.import.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/" //TODO
    filter_suffix       = ".log"     //TODO
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda"
  length = 5
}