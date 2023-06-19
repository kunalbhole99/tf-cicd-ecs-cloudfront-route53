#### Version-2: CloudFront Distribution + private S3 bucket #######

terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "4.65.0" 
    }
  }

  backend "s3" {
    bucket = "my-terraform-backend-statefile"
    region = "ap-south-1"
    key    = "tf-serverless-website/tfproject.tfstate"
  }
}


################# provider for mumbai region ################

provider "aws" {
  region = "ap-south-1"
  
  default_tags {
    tags = {
      project = "web-hosting",
      type    = "web",
      iac     = "terraform"
    }
  }
}

################# provider for north-virginia region ################

provider "aws" {
  alias = "north_virginia"
  region = "us-east-1"
   default_tags {
    tags = {
      project = "web-hosting",
      type    = "web",
      iac     = "terraform"
    }
  }
}