# Create S3 bucket
resource "aws_s3_bucket" "s3_docs" {
  bucket = var.s3_bucket_name
}

# Upload private docs to s3
resource "aws_s3_object" "docs" {
  bucket = var.s3_bucket_name
  key    = "NET-Microservices-Architecture-for-Containerized-NET-Applications"
  source = "docs/NET-Microservices-Architecture-for-Containerized-NET-Applications.pdf"
  depends_on = [ 
    aws_s3_bucket.s3_docs 
  ]
}