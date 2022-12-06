resource "aws_rds_cluster" "db_empowerlabs" {
  cluster_identifier      = "empowerlabs-cluster-db"
  engine                  = "aurora-postgresql"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  database_name           = "mydb"
  db_cluster_instance_class = "db.r6gd.xlarge"
  master_username         = "empowermentlabs"
  master_password         = "empowermentlabs"
  backup_retention_period = 5
  skip_final_snapshot = true
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids = [var.sg-be-id]
  db_subnet_group_name = aws_db_subnet_group.group_empowerlabs.name

  depends_on = [aws_db_subnet_group.group_empowerlabs]
}

resource "aws_db_subnet_group" "group_empowerlabs" {
  name       = "group-subnets-db"
  subnet_ids = [var.private_subnet5_id, var.private_subnet6_id]

  tags = {
    Name = "My DB subnet group"
  }
}