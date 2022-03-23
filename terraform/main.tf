module "database" {
  source = "./database"

  name                        = var.name
  vpc_id                      = var.vpc_id
  subnet_ids                  = var.database_subnet_ids
  bastion_subnet_id           = var.database_bastion_subnet_id
  engine_version              = var.database_engine_version
  incoming_security_group_ids = var.database_incoming_security_group_ids
}
