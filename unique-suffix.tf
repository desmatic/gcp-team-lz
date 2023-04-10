resource "random_string" "unique-suffix" {
  length  = 8
  special = false
  upper   = false
}
