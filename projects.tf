module "logging" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "logging"
  project_id = "logging-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-dev"
  project_id = "monitoring-dev-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-nonprod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-nonprod"
  project_id = "monitoring-nonprod-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-prod"
  project_id = "monitoring-prod-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "vpc-host-dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-dev"
  project_id = "vpc-host-dev-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sre-development.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account
}

module "vpc-host-nonprod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-staging"
  project_id = "vpc-host-nonprod-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sre-staging.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account
}

module "vpc-host-prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-prod"
  project_id = "vpc-host-prod-${random_string.unique-suffix.result}"
  org_id     = var.org_id
  folder_id  = google_folder.sre-production.name

  enable_shared_vpc_host_project = true
  billing_account                = var.billing_account
}
