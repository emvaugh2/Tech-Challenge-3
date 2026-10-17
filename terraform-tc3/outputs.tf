


output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  value = aws_instance.web_server.private_ip
}

output "ansible-node_public_ip" {
  value = aws_instance.ansible_server.public_ip
}