variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west3"
}

variable zone {
  description = "Zone"
  default     = "europe-west3-b"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable gke_cluster_name {
  description = "name of the cluster gke"
  default     = "reddit-gke"
}

variable gke_node_count {
  description = "GKE node count"
  default     = "2"
}

variable gke_cluster_version {
  description = "GKE cluster version"
  default     = "1.13.7-gke.8"
}

variable gke_node_machine_type {
  description = "GKE machine type"
  default     = "g1-small"
}

variable gke_node_image_type {
  description = "GKE Image type"
  default     = "COS"
}

variable gke_node_disk_type {
  description = "GKE node disk type"
  default     = "pd-standard"
}

variable gke_node_disk_size {
  description = "GKE Disk size"
  default     = "20"
}
