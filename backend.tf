terraform {
  backend "s3" {
    bucket       = "terr-state-2729"
    key          = "terraform/terraform.tfstate"
    region       = "ap-south-2"
    use_lockfile = true
  }
}
