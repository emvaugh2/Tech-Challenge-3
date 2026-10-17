# Creates the S3 bucket

resource "aws_s3_bucket" "webserver_bucket" {
  bucket = "tc3-s3-web-server-bucket-3"

  tags = {
    Project = "Tech-Challenge-3"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.webserver_bucket.id
  key          = "website/index.html"
  source       = "${path.module}/../website/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/../website/index.html")
}


resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.webserver_bucket.id
  key          = "website/style.css"
  source       = "${path.module}/../website/style.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/../website/style.css")
}
