module "organization-iam" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.4"

  organizations = [var.org_id]

  bindings = {

    "roles/billing.admin" = [
      "group:gcp-billing-admins@${var.org_domain}",
    ]

    "roles/resourcemanager.organizationAdmin" = [
      "group:gcp-organization-admins@${var.org_domain}",
    ]

  }
}


module "devops-development-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.devops-development.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "devops-staging-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.devops-staging.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "devs-development-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.devs-development.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "devs-staging-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.devs-staging.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "finops-development-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.finops-development.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "finops-staging-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.finops-staging.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "sre-development-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.sre-development.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}


module "sre-staging-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [google_folder.sre-staging.name]

  bindings = {

    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${var.org_domain}",
    ]

    "roles/container.admin" = [
      "group:gcp-developers@${var.org_domain}",
    ]

  }
}
