locals {
  suffix_workspace_id = var.workspace_id != "" ? "-${var.workspace_id}" : ""
  suffix_instance_id  = var.instance_id != "" ? "-${var.instance_id}" : ""
  resource_suffix     = "${local.suffix_workspace_id}${local.suffix_instance_id}"
}
