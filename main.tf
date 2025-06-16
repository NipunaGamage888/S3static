provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static-website" {
  bucket = "my-static-site-nipuna-${random_id.rand.hex}"
  

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static-website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = ["s3:GetObject"],
      Resource = "${aws_s3_bucket.static-website.arn}/*"
    }]
  })
 depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
}

resource "random_id" "rand" {
  byte_length = 4
}
resource "aws_s3_object" "index" {
  bucket        = aws_s3_bucket.static-website.id
  key           = "index.html"
  source        = "${path.module}/../index.html"
  content_type  = "text/html"
}

resource "aws_s3_object" "error" {
  bucket        = aws_s3_bucket.static-website.id
  key           = "error.html"
  source        = "${path.module}/../error.html"
  content_type  = "text/html"
}
