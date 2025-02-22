resource "aws_s3_bucket" "warriror_terraform_state" {
  bucket = "team-warriors-web-server-backend-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "team_warriors_s3_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.warriror_terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
