terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

resource "akeyless_target_db" "root" {
  db_type   = "mysql"
  name      = "${var.akeyless_folder}/root"
  db_name   = aws_rds_cluster.database.database_name
  host      = aws_rds_cluster.database.endpoint
  user_name = "root"
  pwd       = random_password.password.result
  port      = "3306"

  lifecycle {
    # AKeyless will rotate our master password for us and we don't want terraform to reset it,
    # so we need to ignore changes to the master password
    ignore_changes = [pwd]
  }

  depends_on = [aws_rds_cluster_instance.database]
}

#resource "akeyless_producer_mysql" "application" {
#  name = "${var.akeyless_folder}/application"
#  mysql_host = aws_rds_cluster.database.endpoint
#  mysql_dbname = aws_rds_cluster.database.database_name
#  mysql_screation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 1 DAY;GRANT DELETE,INSERT,SELECT,UPDATE ON ${aws_rds_cluster.database.database_name}.* TO '{{name}}'@'%';"
#  mysql_port = "3306"
#  target_name = akeyless_target_db.root.name
#}

#resource "akeyless_producer_mysql" "migration" {
#  name = "${var.akeyless_folder}/migration"
#  mysql_host = aws_rds_cluster.database.endpoint
#  mysql_dbname = aws_rds_cluster.database.database_name
#  mysql_screation_statements = "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}' PASSWORD EXPIRE INTERVAL 1 DAY;GRANT all ON ${aws_rds_cluster.database.database_name}.* TO '{{name}}'@'%';"
#  mysql_port = "3306"
#  target_name = akeyless_target_db.root.name
#}
