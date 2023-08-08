resource "aws_kendra_index" "kendra_docs_index" {
  name        =  var.kendra_index_name
  edition     = var.kendra_index_edition
  role_arn    = aws_iam_role.kendra_role.arn
  depends_on  = [ 
    aws_s3_object.docs, 
    aws_iam_role_policy_attachment.kendra_access_cwl_policy_attachment, 
    aws_iam_role_policy_attachment.kendra_access_s3_policy_attachment 
  ]
}

resource "aws_kendra_data_source" "kendra_docs_s3_connector" {
  index_id = aws_kendra_index.kendra_docs_index.id
  name     = "s3-docs-connector"
  type     = "S3"
  role_arn = aws_iam_role.kendra_role.arn
  schedule = "cron(0/5 * * * ? *)"

  configuration {
    s3_configuration {
      bucket_name = aws_s3_bucket.s3_docs.id
    }
  }
}
