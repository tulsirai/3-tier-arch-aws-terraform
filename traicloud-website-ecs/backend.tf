# store the terraform state file in 3

terraform {
  backend "s3" {
    bucket         = "traicloud-terraform-state"
    key            = "traicloud-website-ecs.state"
    region         = "us-west-2"    
    profile        = "awspsa"
  }
}