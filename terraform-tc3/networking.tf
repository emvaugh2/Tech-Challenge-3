
# Creates the overall VPC
resource "aws_vpc" "supernet" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Project = "Tech-Challenge-3"
  }
}

# Creates a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.supernet.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Project = "Tech-Challenge-3"
  }

}





# Creates the Internet Gateway (IGW)
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.supernet.id

  tags = {
    Project = "Tech-Challenge-3"
  }
}



# Creates the public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.supernet.id

  tags = {
    Project = "Tech-Challenge-3"
  }
}

# Creates the default route for the public route table
resource "aws_route" "default_route_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id


}

# Associates the public route table to the public subnet
resource "aws_route_table_association" "rta_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id


}
