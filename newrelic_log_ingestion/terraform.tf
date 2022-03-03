variable "newrelic_license_key" {
  type = string
}

variable "newrelic_account_id" {
  type = string
}

variable "newrelic_api_key" {
  type = string
}
module "newrelic_log_ingestion" {
  source                       = "github.com/newrelic/aws-log-ingestion"
  service_name                 = "apm-newrelic-log-ingestion"
  nr_license_key               = var.newrelic_license_key
  nr_logging_enabled           = true
  lambda_archive               = "src/newrelic-log-ingestion.zip"
  lambda_log_retention_in_days = 14
}

terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = "US"
}

provider "aws" {
  region = "ap-northeast-1"
}
