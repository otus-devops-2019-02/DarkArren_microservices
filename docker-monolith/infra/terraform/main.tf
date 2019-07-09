provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source          = "./modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.disk_image}"
  private_key_path    = "${var.private_key_path}"
  vm_count = "${var.vm_count}"
}
