output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_ip" {
  value = aws_instance.my_amazon.public_ip
} 

output "eip" {
  value = aws_eip.default.id
}