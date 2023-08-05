variable "s3_bucket_name" {
    description = "The name of the s3 bucket"
    type        = string
    default     = "s3-mtr-rag-docs-demo"
}

variable "kendra_index_name" {
    description = "Specifies the name of the Kendra Index."
    type        = string
    default     = "kendra-mtr-rag-docs-demo"
}

variable "kendra_index_edition" {
    description = "The Amazon Kendra edition to use for the index"
    type        = string
    default     = "DEVELOPER_EDITION"
}