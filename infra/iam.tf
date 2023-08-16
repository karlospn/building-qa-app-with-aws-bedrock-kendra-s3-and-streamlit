# Create IAM role for Kendra
resource "aws_iam_role" "kendra_role" {
  name = "kendra-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "kendra.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Create IAM policy for enabling Kendra to access CloudWatch Logs
resource "aws_iam_policy" "kendra_cwl_access_policy" {
  name        = "kendra-cwl-access-policy"
  path        = "/"
  description = "IAM policy for enabling Kendra to access CloudWatch Logs"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "cloudwatch:namespace": "AWS/Kendra"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kendra/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kendra/*:log-stream:*"
            ]
        }
    ]
}
EOF
}


# Create IAM policy for enabling Kendra to access and index S3
resource "aws_iam_policy" "kendra_s3_access_policy" {
  name        = "iam-kendra-access-s3-access-policy"
  path        = "/"
  description = "IAM policy for enabling Kendra to access and index S3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}"
            ],
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kendra:BatchPutDocument",
                "kendra:BatchDeleteDocument"
            ],
            "Resource": "arn:aws:kendra:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:index/*"
        }
    ]
}
EOF
}

# Add policy to role
resource "aws_iam_role_policy_attachment" "kendra_access_cwl_policy_attachment" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = aws_iam_policy.kendra_cwl_access_policy.arn
}

# Add policy to role
resource "aws_iam_role_policy_attachment" "kendra_access_s3_policy_attachment" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = aws_iam_policy.kendra_s3_access_policy.arn
}