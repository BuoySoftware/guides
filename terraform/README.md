
# Terraform

## Resource Naming

- Prefer lowercase, underscored resource names, ie `my_special_resource` over `my-special-resource`
- Prefer singular resource names over plural, ie `my_special_resource` over `my_special_resources`
- Prefer simple resource naming when a resource is the only one of its type, i.e.  `main`, `this`,  or `default`
- Prefer meaningful resource names when differentiating between multiple resources of the same type, ie `my_special_resource` 
- Don't give the resource the same name as the type, ie `data "aws_iam_policy_document" "iam_policy_document"`

## Sharable Resources

- Place custom modules in a common directory, ie `/common`
- Ensure custom modules all follow the example module, including all files even if empty (see example_module directory)
- Ensure custom modules are account, client and/or environment agnostic
- Prefer input variables over hard coded values for easier reuse and extensibility
- Ensure input variables have a type, description and validation
- Prefer a relative source path during development, ie `source = "../common/kms"`
- Prefer a pinned, remote source path once development is complete, ie `source = "git@github.com:BuoySoftware/terraform-infrastructure-aws.git//common/kms?ref=dea56f7"`

## Directory Structure for AWS Resources

- Prefer splitting accounts up by directory over putting all accounts in the same folder, ie `/nonprod`, `/prod`, `/cicd`
- Prefer a platform subfolder for common, base level resources of the account, ie `/nonprod/platform`
- Prefer a client subfolder for resources specific to clients within the account, ie `/nonprod/abc` 
- Prefer a regional subfolder to organize resources for different regions of a client, ie `/nonprod/platform/us-east-1` and `/nonprod/abc/us-east-1`
- Prefer a platform subfolder for common, base level resources of a client's region, ie `/nonprod/abc/us-east-1/platform`
- Prefer each resource within the client's region is listed in a subfolder with a human readable name, ie `/nonprod/platform/us-east-1/vpc` and  `/nonprod/abc/us-east-1/eks`

### Example directories:

* /nonprod/platform/us-east-1/vpc
* /nonprod/platform/us-east-1/guardduty
* /nonprod/platform/us-east-1/iam
* /nonprod/abc/us-east-1/platform/eks
* /nonprod/abc/us-east-1/staging/rds
* /nonprod/abc/us-east-1/staging/elasticache
* /nonprod/abc/us-east-1/qa/rds
* /nonprod/abc/us-east-1/qa/elasticache
* /nonprod/def/us-east-1/platform/eks
* /nonprod/def/us-east-1/staging/rds
* /nonprod/def/us-east-1/staging/elasticache
* /nonprod/def/us-east-1/qa/rds
* /nonprod/def/us-east-1/qa/elasticache
