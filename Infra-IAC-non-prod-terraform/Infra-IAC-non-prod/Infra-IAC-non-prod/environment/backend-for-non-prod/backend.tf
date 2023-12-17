##################PROVIDER###########################
provider "aws" {
  region = "us-east-1"
}

#############S3 STATE BUCKET###########################
resource "aws_s3_bucket" "state-bucket" {
  bucket = "woooba-non-prod-terraform-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-encrypt" {
  bucket = aws_s3_bucket.state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
#############DYNAMODB TABLE###########################
resource "aws_dynamodb_table" "state-lock" {
    name           = "woooba-non-prod-terraform-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key       = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}    