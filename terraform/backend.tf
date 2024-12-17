terraform {
  backend "s3" {
    bucket = "tf-backend-capstone"
    key    = "capstone/project1/infra.tfstate"
    region = "us-east-1"
    #dynamodb_table = "your-dynamodb-table"
  }
}
