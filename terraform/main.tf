module "database" {
  source = "./database"

  name                        = var.name
  vpc_id                      = var.vpc_id
  subnet_ids                  = var.database_subnet_ids
  engine_version              = var.database_engine_version
  incoming_security_group_ids = var.database_incoming_security_group_ids
}
