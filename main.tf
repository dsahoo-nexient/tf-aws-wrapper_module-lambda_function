// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# Module to generate the AWS resource names
module "resource_names" {
  source = "github.com/nexient-llc/tf-module-resource_name.git?ref=0.3.0"

  for_each = var.resource_names_map

  logical_product_name = var.naming_prefix
  region               = join("", split("-", var.region))
  class_env            = var.environment
  cloud_resource_type  = each.value.name
  instance_env         = var.environment_number
  instance_resource    = var.resource_number
  maximum_length       = each.value.max_length
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.1"

  vpc_id                   = var.vpc_id
  name                     = module.resource_names["security_group"].standard
  description              = "Security Group for Lambda functions"
  ingress_with_cidr_blocks = var.ingress_rules

  egress_with_cidr_blocks = var.egress_rules

  tags = merge(var.tags, { resource_name = module.resource_names["security_group"].standard })
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = module.resource_names["function"].standard
  description   = var.function_description
  handler       = var.handler
  runtime       = var.runtime

  # source_path = "../fixtures/python3.8-app1"
  local_existing_package = "${path.module}/${var.zip_file_path}"
  create_package         = false

  vpc_subnet_ids             = var.private_subnets
  vpc_security_group_ids     = [module.security_group.security_group_id]
  attach_network_policy      = true
  environment_variables      = var.environment_variables
  create_lambda_function_url = var.create_lambda_function_url
  publish                    = var.publish
  attach_policy_json         = var.attach_policy_json
  policy_json                = var.policy_json
  attach_policies            = var.attach_policies
  number_of_policies         = var.number_of_policies
  policies                   = var.policies

  tags = merge(var.tags, { resource_name = module.resource_names["function"].standard })
}
