terraform {
  required_providers {
    aws = {}
  }
}

module "context" {
  source  = "git@github.com:BuoySoftware/terraform-infrastructure-aws.git//modules/context?ref=14f90eb"
  context = var.context
  tags    = var.tags
}
