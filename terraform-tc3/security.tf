

# Creates the security group for the web server server
resource "aws_security_group" "webserver_sg" {
  name        = "Web-Server-Security-Group"
  description = "This is the security group for the web server"
  vpc_id      = aws_vpc.supernet.id

  ingress {
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }




  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }



  tags = {
    Project = "Tech-Challenge-3"
  }
}

data "http" "webserver_public_ip" {
  url = "https://api.ipify.org"
}