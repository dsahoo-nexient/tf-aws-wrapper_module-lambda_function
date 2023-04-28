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

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "nexgen"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    function = {
      name       = "fn"
      max_length = 64
    }
    security_group = {
      name       = "sg"
      max_length = 60
    }
  }
}

variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "function_description" {
  description = "Description of the lambda function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Name of the lambda handler"
  type        = string
}

variable "runtime" {
  description = "Runtime of the lambda function. Valid values are: nodejs | nodejs4.3 | nodejs6.10 | nodejs8.10 | nodejs10.x | nodejs12.x | nodejs14.x | nodejs16.x | java8 | java8.al2 | java11 | python2.7 | python3.6 | python3.7 | python3.8 | python3.9 | dotnetcore1.0 | dotnetcore2.0 | dotnetcore2.1 | dotnetcore3.1 | dotnet6 | nodejs4.3-edge | go1.x | ruby2.5 | ruby2.7 | provided | provided.al2 | nodejs18.x"
  type        = string
}

variable "zip_file_path" {
  description = "Path of the source zip file with respect to module root"
  type        = string
}

variable "publish" {
  description = "Whether to publish the lambda function"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "A map of environment variables"
  type        = map(string)
  default     = {}
}

### VPC related variables
variable "vpc_id" {
  description = "The VPC ID of the VPC where infrastructure will be provisioned"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "ingress_rules" {
  description = "Ingress rules to be attached to ECS Service Security Group"
  type = list(object({
    cidr_blocks = string
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
  }))
  default = []
}

variable "egress_rules" {
  description = "Egress rules to be attached to ECS Service Security Group"
  type = list(object({
    cidr_blocks = string
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
  }))
  default = [{
    cidr_blocks = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
  }]
}

variable "create_lambda_function_url" {
  description = "Whether to create a lambda function URL"
  type        = bool
  default     = false
}

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}

variable "policies" {
  description = "List of policy statements ARN to attach to Lambda Function role"
  type        = list(string)
  default     = []
}

variable "attach_policies" {
  description = "Controls whether list of policies should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "number_of_policies" {
  description = "Number of policies to attach to IAM role for Lambda Function"
  type        = number
  default     = 0
}

variable "tags" {
  description = "A map of custom tags to be attached to the function"
  type        = map(string)
  default     = {}
}
