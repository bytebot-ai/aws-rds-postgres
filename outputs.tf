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
  description = "The master password (sensitive)"
  value       = var.password
  sensitive   = true
}

output "db_connection_uri" {
  description = "PostgreSQL connection URI including credentials (sensitive)"
  value = format(
    "postgresql://%s:%s@%s:%d/%s",
    urlencode(var.username),
    urlencode(var.password),
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    urlencode(var.database_name),
  )
  sensitive = true
}

output "db_connection_uri_with_env_password" {
  description = "PostgreSQL connection URI using $(DB_PASSWORD) placeholder"
  value = format(
    "postgresql://%s:$(DB_PASSWORD)@%s:%d/%s",
    urlencode(var.username),
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    urlencode(var.database_name),
  )
}
