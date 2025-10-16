
module "labels" {
  source = "../../"

  labels = {
    env = "prd"
    # cloudautomation is mandatory and cannot be overridden
    costcenter = "666_666_666_666"
    pii        = "true"
    # example of overriding appid
    appid = "0000"
    # example of a key that the caller wants to make sure is provided
    some-none-std-key-that-we-want-to-have = "value"
  }

  # optional disable any validation and overriding
  disable_validation = false

}

output "merged_labels" {
  value = module.labels.labels
}
