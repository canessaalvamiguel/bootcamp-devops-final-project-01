resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-balanced"
    disk_size_gb = 80
  }

  network    = "default"
  subnetwork = "default"
  depends_on = [ google_project_service.gke, google_project_service.cloudresourcemanager ]
}


resource "google_artifact_registry_repository" "docker_repo_backend" {
  provider = google
  project  = var.project_id
  location = var.region
  repository_id = var.repository_name_backend
  format = "DOCKER"
  depends_on = [ google_project_service.artifact_registry ]
}

resource "google_artifact_registry_repository" "docker_repo_frontend" {
  provider = google
  project  = var.project_id
  location = var.region
  repository_id = var.repository_name_frontend
  format = "DOCKER"
  depends_on = [ google_project_service.artifact_registry ]
}