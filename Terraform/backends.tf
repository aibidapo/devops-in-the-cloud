terraform {
  cloud {
    organization = "AI-CloudOps"

    workspaces {
      name = "devops-aws-infra-dev"
    }
  }
}