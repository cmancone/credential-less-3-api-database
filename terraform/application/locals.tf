locals {
  name = "${var.name}-application"
  tags = merge(var.tags, {
    Name = "${var.name}-application"
  })
}
