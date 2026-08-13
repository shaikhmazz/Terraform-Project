resource "aws_s3_bucket" "mazz-s3" {
  bucket = "mazz-tf-test-bucket-2026"

  tags = {
    Name        = "mazz-s3"
    Environment = "Dev"
  }
}
