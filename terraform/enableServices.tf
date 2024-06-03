resource "google_project_service" "gke" {
  service = "container.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
  project = var.project_id
}