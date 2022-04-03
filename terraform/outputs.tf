output "migration_lambda_name" {
  value       = module.database.migration_lambda_name
  description = "The name of the lambda used for database migrations"
}

output "migration_lambda_arn" {
  value       = module.database.migration_lambda_arn
  description = "The ARN of the lambda used for database migrations"
}

output "database_host" {
  value       = module.database.database_host
  description = "The write endpoint for the database cluster"
}

output "database_name" {
  value       = module.database.database_name
  description = "The database name for the service"
}

output "bastion_public_ip" {
  value       = module.database.bastion_public_ip
  description = "The ip address of the bastion"
}
