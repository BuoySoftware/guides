variable "context" {
  description = "Single object for setting entire context at once. See [context module](https://github.com/BuoySoftware/terraform-infrastructure-aws/tree/main/modules/context)."
  default     = null
  type        = any
}

variable "tags" {
  description = "Additional tags to include on all resources."
  default     = {}
  type        = map(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the resource will be created."
  type        = string
}
