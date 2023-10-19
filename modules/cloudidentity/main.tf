locals {
  suffix_instance_id = var.instance_id != "" ? "-${var.instance_id}" : ""
  suffix_custom      = var.suffix != "" ? "-${var.suffix}" : ""
  resource_suffix    = "${local.suffix_instance_id}${local.suffix_custom}"
}
