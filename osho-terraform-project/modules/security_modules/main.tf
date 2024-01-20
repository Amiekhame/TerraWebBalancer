resource "aws_security_group" "sg_1" {
    description = "Allow ssh conection on port 22, allow http on port 80, allow https on port 443, allow all ICMP traffic"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow ssh conection on port 22"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow http conection on port 80"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow https conection on port 443"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        description = "allow all ICMP traffic"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"] 

    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}_sg_1"
    }
}

###################################################

resource "aws_security_group" "sg_2" {
    description = "allow only http and https traffics"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow http conection on port 80"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow https conection on port 443"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}_sg_2"
    }
}
