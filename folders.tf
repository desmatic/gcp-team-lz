resource "google_folder" "common" {
  display_name = "Common"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "devops" {
  display_name = "DevOps"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "devops-development" {
  display_name = "Development"
  parent       = google_folder.devops.name
}

resource "google_folder" "devops-production" {
  display_name = "Production"
  parent       = google_folder.devops.name
}

resource "google_folder" "devops-staging" {
  display_name = "Staging"
  parent       = google_folder.devops.name
}

resource "google_folder" "devs" {
  display_name = "Devs"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "devs-development" {
  display_name = "Development"
  parent       = google_folder.devs.name
}

resource "google_folder" "devs-production" {
  display_name = "Production"
  parent       = google_folder.devs.name
}

resource "google_folder" "devs-staging" {
  display_name = "Staging"
  parent       = google_folder.devs.name
}

resource "google_folder" "finops" {
  display_name = "FinOps"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "finops-development" {
  display_name = "Development"
  parent       = google_folder.finops.name
}

resource "google_folder" "finops-production" {
  display_name = "Production"
  parent       = google_folder.finops.name
}

resource "google_folder" "finops-staging" {
  display_name = "Staging"
  parent       = google_folder.finops.name
}

resource "google_folder" "sre" {
  display_name = "SRE"
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "sre-development" {
  display_name = "Development"
  parent       = google_folder.sre.name
}

resource "google_folder" "sre-production" {
  display_name = "Production"
  parent       = google_folder.sre.name
}

resource "google_folder" "sre-staging" {
  display_name = "Staging"
  parent       = google_folder.sre.name
}
