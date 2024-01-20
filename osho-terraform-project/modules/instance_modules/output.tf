output "aws_instance_vm1" {
    value = aws_instance.vm1.public_ip
}

output "aws_instance_vm2" {
    value = aws_instance.vm2.public_ip
}

output "aws_instance_vm3" {
    value = aws_instance.vm3.public_ip
}
