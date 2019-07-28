provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name               = "${var.gke_cluster_name}"
  zone               = "${var.zone}"
  remove_default_node_pool = true
  initial_node_count = 1
  min_master_version = "1.13.7-gke.8"

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    kubernetes_dashboard {
      disabled = false
    }
  }

  enable_legacy_abac = true

  timeouts {
    create = "15m"
    update = "30m"
  }

  # provisioner "local-exec" {
  #   command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --zone ${var.zone} --project ${var.project} && kubectl apply -f ../reddit/dev-namespace.yml && kubectl apply -f ../reddit/ -n dev && kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard"
  # }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --zone ${var.zone} --project ${var.project} && kubectl apply -f ../reddit/tiller.yml && helm init --service-account tiller && kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard"
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "reddit-node-pool"
  zone   = "${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.gke_node_count}"

  node_config {
    preemptible  = true
    disk_size_gb = "${var.gke_node_disk_size}"
    disk_type = "${var.gke_node_disk_type}"
    image_type = "${var.gke_node_image_type}"
    machine_type = "${var.gke_node_machine_type}"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

resource "google_container_node_pool" "bigpool" {
  name       = "bigpool"
  zone   = "${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    disk_size_gb = "30"
    disk_type    = "pd-standard"
    image_type   = "COS"
    machine_type = "n1-standard-2"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

module "vpc" {
  source        = "./modules/vpc"
  source_ranges = "${var.source_ranges}"
}
