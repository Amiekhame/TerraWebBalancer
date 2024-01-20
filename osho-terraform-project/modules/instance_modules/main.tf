data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}

resource "tls_private_key" "rsa-key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "key-pair" {
    key_name = "${var.project_name}-key"
    public_key = tls_private_key.rsa-key.public_key_openssh 
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa-key.private_key_pem
    filename = "${var.project_name}-key.pem"
}



resource "aws_instance" "vm1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.key-pair.key_name
    subnet_id = var.subnet_a_id
    vpc_security_group_ids = [var.sg_1_id]
    
    tags = {
        Name = "${var.project_name}-vm1"
    }
}


resource "aws_instance" "vm2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.key-pair.key_name
    subnet_id = var.subnet_b_id
    vpc_security_group_ids = [var.sg_1_id]
    
    tags = {
        Name = "${var.project_name}-vm2"
    }
}

resource "aws_instance" "vm3" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.key-pair.key_name
    subnet_id = var.subnet_c_id
    vpc_security_group_ids = [var.sg_1_id]
    
    tags = {
        Name = "${var.project_name}-vm3"
    }
}



resource "local_file" "host_inventory" {
    depends_on = [aws_instance.vm1, aws_instance.vm2, aws_instance.vm3]

    filename = "host-inventory"
    content  = join("\n", [
        "ubuntu@${aws_instance.vm1.public_ip}",
        "ubuntu@${aws_instance.vm2.public_ip}",
        "ubuntu@${aws_instance.vm3.public_ip}",
    ])
}


