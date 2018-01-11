provider "aws" {
  version = "~> 1.6"
  region  = "${var.region}"
}

provider "template" {
  version = "~> 1.0"
}

provider "archive" {
  version = "~> 1.0"
}

