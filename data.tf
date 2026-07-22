data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "instance_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "managed_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ])
  arn = each.value
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    sid       = "ReadDatabaseSecret"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [module.database.db_master_secret_arn]
  }
  statement {
    sid       = "WriteReportsToS3"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.s3_bucket.bucket_arn}/reports/*"]
  }
}
