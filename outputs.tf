output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.this.id
}

output "db_security_group_id" {
  description = "The security group ID"
  value       = aws_security_group.this.id
}

output "db_master_password" {
  description = "The generated master password (sensitive)"
  value       = random_password.master.result
  sensitive   = true
}

output "db_connection_uri" {
  description = "PostgreSQL connection URI including credentials (sensitive)"
  value = format(
    "postgresql://%s:%s@%s:%d/%s",
    urlencode(var.username),
    urlencode(random_password.master.result),
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    urlencode(var.database_name),
  )
  sensitive = true
}
