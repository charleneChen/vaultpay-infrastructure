terraform {
  backend "s3" {
    bucket       = "s3-terraform-state-store-2026"
    key          = "vaultpay/terraform.tfstate"
    region       = "us-east-1"
    profile      = "iamadmin-general"
    encrypt      = true
    use_lockfile = true

  }
}
