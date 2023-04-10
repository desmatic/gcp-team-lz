module "logsink-logbucketsink" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.3.0"

  destination_uri      = module.logging-destination.destination_uri
  log_sink_name        = "logbucketsink_${random_string.unique-suffix.result}"
  parent_resource_id   = var.org_id
  parent_resource_type = "organization"
  include_children     = true
}

module "logging-destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 7.4.1"

  project_id               = module.logging.project_id
  name                     = "logbucketsink_${random_string.unique-suffix.result}"
  location                 = "global"
  retention_days           = 365
  log_sink_writer_identity = module.logsink-logbucketsink.writer_identity
}
