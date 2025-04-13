terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "aws_s3_bucket" "demo_bucket" {
    bucket = "static-website-seif2"
    force_destroy = true 
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_acess" {
  bucket = aws_s3_bucket.demo_bucket.id
  policy = jsonencode(
    {
        Version = "2012-10-17"
        Statement = [
            {
                Sid= "PublicReadGetObject",
                Effect = "allow",
                Principal = "*",
                Action = "s3:GetObject",
            Resource = "arn:aws:s3:::${aws_s3_bucket.demo_bucket.id}/*"
            }
        ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "site_hosting" {
    bucket = aws_s3_bucket.demo_bucket.id

    index_document {
      
      suffix = "index.html"
    }
  
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.demo_bucket.id
  key          = "index.html"
  source       = "index.html"  
  content_type = "text/html"
}