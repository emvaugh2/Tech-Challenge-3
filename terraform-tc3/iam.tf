########################################################################
######################## Web Server IAM Section ########################
########################################################################


# Defines which AWS service is allowed to assume the web server IAM role.
# In this project, the EC2 service is trusted to assume the role.
data "aws_iam_policy_document" "webserver_assume_role_policy" {

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


# Creates the IAM role used by the web server EC2 instance.
resource "aws_iam_role" "webserver_role" {
  name = "tc3-web-server-role"

  assume_role_policy = data.aws_iam_policy_document.webserver_assume_role_policy.json

  tags = {
    Project = "Tech-Challenge-3"
  }
}


########################################################################
######################## S3 Permissions ################################
########################################################################


# Defines the permissions required for the web server to retrieve
# website files from the TC3 S3 bucket.
data "aws_iam_policy_document" "webserver_s3_policy" {

  # Allows the EC2 instance to list the contents of the website bucket.
  statement {
    sid    = "ListWebsiteBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.webserver_bucket.arn
    ]
  }


  # Allows the EC2 instance to retrieve objects stored in the website bucket.
  statement {
    sid    = "ReadWebsiteObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.webserver_bucket.arn}/*"
    ]
  }
}


# Creates the IAM policy containing the S3 read permissions.
resource "aws_iam_policy" "webserver_s3_policy" {
  name        = "tc3-web-server-s3-read-policy"
  description = "Allows the TC3 web server to retrieve website files from its S3 bucket."

  policy = data.aws_iam_policy_document.webserver_s3_policy.json

  tags = {
    Project = "Tech-Challenge-3"
  }
}


# Attaches the S3 read policy to the web server IAM role.
resource "aws_iam_role_policy_attachment" "webserver_s3_policy_attachment" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = aws_iam_policy.webserver_s3_policy.arn
}


########################################################################
######################## EC2 Instance Profile ##########################
########################################################################


# Creates the instance profile that provides the IAM role to the EC2 instance.
resource "aws_iam_instance_profile" "webserver_instance_profile" {
  name = "tc3-webserver-instance-profile"
  role = aws_iam_role.webserver_role.name

  tags = {
    Project = "Tech-Challenge-3"
  }
}