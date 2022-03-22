locals {
  name = "${var.name}-db"
  tags = merge(var.tags, {
    Name = "${var.name}-db"
  })
}
