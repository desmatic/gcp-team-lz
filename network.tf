# VPC and Subnets
module "vpc-dev-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.vpc-host-dev.project_id
  network_name = "vpc-dev-shared"
  routing_mode = "GLOBAL"

  subnets = [

    {
      subnet_name               = "subnet-dev-1"
      subnet_ip                 = "10.80.0.0/16"
      subnet_region             = "us-central1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
    {
      subnet_name               = "subnet-dev-2"
      subnet_ip                 = "10.96.0.0/16"
      subnet_region             = "us-west1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]

  routes = [
    {
      name              = "rt-vpc-dev-shared-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]
}
# Firewall Rules
resource "google_compute_firewall" "vpc-dev-shared-allow-iap-rdp" {
  name      = "vpc-dev-shared-allow-iap-rdp"
  network   = module.vpc-dev-shared.network_name
  project   = module.vpc-host-dev.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["3389", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-dev-shared-allow-iap-ssh" {
  name      = "vpc-dev-shared-allow-iap-ssh"
  network   = module.vpc-dev-shared.network_name
  project   = module.vpc-host-dev.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-dev-shared-allow-icmp" {
  name      = "vpc-dev-shared-allow-icmp"
  network   = module.vpc-dev-shared.network_name
  project   = module.vpc-host-dev.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.128.0.0/9",
  ]
}
# NAT Router and config
resource "google_compute_router" "cr-vpc-dev-shared-sb0-us-central1-router" {
  name    = "cr-vpc-dev-shared-sb0-us-central1-router"
  project = module.vpc-host-dev.project_id
  region  = "us-central1"
  network = module.vpc-dev-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-dev-shared-sb0-us-central1-egress" {
  name                               = "rn-vpc-dev-shared-sb0-us-central1-egress"
  project                            = module.vpc-host-dev.project_id
  router                             = google_compute_router.cr-vpc-dev-shared-sb0-us-central1-router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-dev-shared-sb0-us-central1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-dev-shared-sb0-us-central1-1" {
  project = module.vpc-host-dev.project_id
  name    = "ca-vpc-dev-shared-sb0-us-central1-1"
  region  = "us-central1"
}
resource "google_compute_router" "cr-vpc-dev-shared-sb1-us-west1-router" {
  name    = "cr-vpc-dev-shared-sb1-us-west1-router"
  project = module.vpc-host-dev.project_id
  region  = "us-west1"
  network = module.vpc-dev-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-dev-shared-sb1-us-west1-egress" {
  name                               = "rn-vpc-dev-shared-sb1-us-west1-egress"
  project                            = module.vpc-host-dev.project_id
  router                             = google_compute_router.cr-vpc-dev-shared-sb1-us-west1-router.name
  region                             = "us-west1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-dev-shared-sb1-us-west1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-dev-shared-sb1-us-west1-1" {
  project = module.vpc-host-dev.project_id
  name    = "ca-vpc-dev-shared-sb1-us-west1-1"
  region  = "us-west1"
}

# VPC and Subnets
module "vpc-prod-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.vpc-host-prod.project_id
  network_name = "vpc-prod-shared"
  routing_mode = "GLOBAL"

  subnets = [

    {
      subnet_name               = "subnet-prod-1"
      subnet_ip                 = "10.16.0.0/16"
      subnet_region             = "us-central1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
    {
      subnet_name               = "subnet-prod-2"
      subnet_ip                 = "10.32.0.0/16"
      subnet_region             = "europe-west1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]

  routes = [
    {
      name              = "rt-vpc-prod-shared-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]
}
# Firewall Rules
resource "google_compute_firewall" "vpc-prod-shared-allow-iap-rdp" {
  name      = "vpc-prod-shared-allow-iap-rdp"
  network   = module.vpc-prod-shared.network_name
  project   = module.vpc-host-prod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["3389", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-prod-shared-allow-iap-ssh" {
  name      = "vpc-prod-shared-allow-iap-ssh"
  network   = module.vpc-prod-shared.network_name
  project   = module.vpc-host-prod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-prod-shared-allow-icmp" {
  name      = "vpc-prod-shared-allow-icmp"
  network   = module.vpc-prod-shared.network_name
  project   = module.vpc-host-prod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.128.0.0/9",
  ]
}
# NAT Router and config
resource "google_compute_router" "cr-vpc-prod-shared-sb0-us-central1-router" {
  name    = "cr-vpc-prod-shared-sb0-us-central1-router"
  project = module.vpc-host-prod.project_id
  region  = "us-central1"
  network = module.vpc-prod-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-prod-shared-sb0-us-central1-egress" {
  name                               = "rn-vpc-prod-shared-sb0-us-central1-egress"
  project                            = module.vpc-host-prod.project_id
  router                             = google_compute_router.cr-vpc-prod-shared-sb0-us-central1-router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-prod-shared-sb0-us-central1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-prod-shared-sb0-us-central1-1" {
  project = module.vpc-host-prod.project_id
  name    = "ca-vpc-prod-shared-sb0-us-central1-1"
  region  = "us-central1"
}
resource "google_compute_router" "cr-vpc-prod-shared-sb1-europe-west1-router" {
  name    = "cr-vpc-prod-shared-sb1-europe-west1-router"
  project = module.vpc-host-prod.project_id
  region  = "europe-west1"
  network = module.vpc-prod-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-prod-shared-sb1-europe-west1-egress" {
  name                               = "rn-vpc-prod-shared-sb1-europe-west1-egress"
  project                            = module.vpc-host-prod.project_id
  router                             = google_compute_router.cr-vpc-prod-shared-sb1-europe-west1-router.name
  region                             = "europe-west1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-prod-shared-sb1-europe-west1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-prod-shared-sb1-europe-west1-1" {
  project = module.vpc-host-prod.project_id
  name    = "ca-vpc-prod-shared-sb1-europe-west1-1"
  region  = "europe-west1"
}

# VPC and Subnets
module "vpc-staging-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.vpc-host-nonprod.project_id
  network_name = "vpc-staging-shared"
  routing_mode = "GLOBAL"

  subnets = [

    {
      subnet_name               = "subnet-non-prod-1"
      subnet_ip                 = "10.48.0.0/16"
      subnet_region             = "us-central1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
    {
      subnet_name               = "subnet-non-prod-2"
      subnet_ip                 = "10.64.0.0/16"
      subnet_region             = "europe-west1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]

  routes = [
    {
      name              = "rt-vpc-staging-shared-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      priority          = "1000"
      next_hop_internet = "true"
      tags              = "egress-internet"
    },
  ]
}
# Firewall Rules
resource "google_compute_firewall" "vpc-staging-shared-allow-iap-rdp" {
  name      = "vpc-staging-shared-allow-iap-rdp"
  network   = module.vpc-staging-shared.network_name
  project   = module.vpc-host-nonprod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["3389", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-staging-shared-allow-iap-ssh" {
  name      = "vpc-staging-shared-allow-iap-ssh"
  network   = module.vpc-staging-shared.network_name
  project   = module.vpc-host-nonprod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-staging-shared-allow-icmp" {
  name      = "vpc-staging-shared-allow-icmp"
  network   = module.vpc-staging-shared.network_name
  project   = module.vpc-host-nonprod.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.128.0.0/9",
  ]
}
# NAT Router and config
resource "google_compute_router" "cr-vpc-staging-shared-sb0-us-central1-router" {
  name    = "cr-vpc-staging-shared-sb0-us-central1-router"
  project = module.vpc-host-nonprod.project_id
  region  = "us-central1"
  network = module.vpc-staging-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-staging-shared-sb0-us-central1-egress" {
  name                               = "rn-vpc-staging-shared-sb0-us-central1-egress"
  project                            = module.vpc-host-nonprod.project_id
  router                             = google_compute_router.cr-vpc-staging-shared-sb0-us-central1-router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-staging-shared-sb0-us-central1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-staging-shared-sb0-us-central1-1" {
  project = module.vpc-host-nonprod.project_id
  name    = "ca-vpc-staging-shared-sb0-us-central1-1"
  region  = "us-central1"
}
resource "google_compute_router" "cr-vpc-staging-shared-sb1-europe-west1-router" {
  name    = "cr-vpc-staging-shared-sb1-europe-west1-router"
  project = module.vpc-host-nonprod.project_id
  region  = "europe-west1"
  network = module.vpc-staging-shared.network_self_link
}

resource "google_compute_router_nat" "rn-vpc-staging-shared-sb1-europe-west1-egress" {
  name                               = "rn-vpc-staging-shared-sb1-europe-west1-egress"
  project                            = module.vpc-host-nonprod.project_id
  router                             = google_compute_router.cr-vpc-staging-shared-sb1-europe-west1-router.name
  region                             = "europe-west1"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.ca-vpc-staging-shared-sb1-europe-west1-1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}

resource "google_compute_address" "ca-vpc-staging-shared-sb1-europe-west1-1" {
  project = module.vpc-host-nonprod.project_id
  name    = "ca-vpc-staging-shared-sb1-europe-west1-1"
  region  = "europe-west1"
}
