locals {
  name = "${var.name}-db"
  tags = merge(var.tags, {
    Name = "${var.name}-db"
  })
  bastion_name = "${var.name}-db-bastion"
  bastion_tags = merge(var.tags, {
    Name = "{$var.name}-db-bastion"
  })
}
