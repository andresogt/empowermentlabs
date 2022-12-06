output "vpc_id" {
  description = "Id de la VPN Simetrik"
  value       = aws_vpc.vpc_prueba_empowermentlabs.id
}

output "private_subnet1_id" {
  description = "Id of public subnet 1"
  value       = aws_subnet.private_subnet1.id
}

output "private_subnet2_id" {
  description = "Id of public subnet 2"
  value       = aws_subnet.private_subnet2.id
}

output "private_subnet3_id" {
  description = "Id of public subnet 3"
  value       = aws_subnet.private_subnet3.id
}

output "private_subnet4_id" {
  description = "Id of public subnet 4"
  value       = aws_subnet.private_subnet4.id
}


output "private_subnet5_id" {
  description = "Id of public subnet 5"
  value       = aws_subnet.private_subnet5.id
}

output "private_subnet6_id" {
  description = "Id of public subnet 6"
  value       = aws_subnet.private_subnet6.id
}

output "public_subnet1_id" {
  description = "Id of public subnet 1"
  value       = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  description = "Id of public subnet 2"
  value       = aws_subnet.public_subnet2.id
}