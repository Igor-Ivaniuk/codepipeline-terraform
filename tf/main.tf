# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "iivaniuk.createdbytf"
}

resource "aws_s3_bucket_ownership_controls" "mybucket_owncontrol" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "private" {
  depends_on = [aws_s3_bucket_ownership_controls.mybucket_owncontrol]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"
}

resource "aws_instance" "t3large" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.large"

  tags = {
    Name = "Server-t3.large"
  }
}

# resource "aws_instance" "t3nano" {
#   ami           = data.aws_ami.amazon-linux-2.id
#   instance_type = "t3.nano"

#   tags = {
#     Name = "Server-t3.nano"
#   }
# }

# resource "aws_instance" "t32xlarge" {
#   ami           = data.aws_ami.amazon-linux-2.id
#   instance_type = "t3.2xlarge"

#   tags = {
#     Name = "Server--t3.2xlarge"
#   }
# }
