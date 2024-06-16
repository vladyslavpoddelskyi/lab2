terraform {
	required_providers {
	aws = {
 		source = "hashicorp/aws"
 		version = "~> 4.0"
 		}
 	}
}


# Configure AWS provider and creds
provider "aws" {
 	region	= "us-east-1"
	access_key = "ASIAZI2LHHY3NLEOK67G"
	secret_key = "Z30cpKDSpJ+X/e4/YpZ9l+j6TgDZPjEgEgqYQ861"
	token = "IQoJb3JpZ2luX2VjED0aCXVzLXdlc3QtMiJHMEUCICKz9aYESp/7Z1xLOqktB7/bs9SZrAu8F0lnajcMMTLAAiEAtp97xCwVGWouJoLy3IEIxQVahLT0spEODYG444rHlYQqtgII1v//////////ARAAGgw2Mzc0MjM1MzM2MjIiDKyICR95GEHiVm7WlSqKAulywCswEifZlT7Rgd8NT267yoEhGbrKzFLnWr21LOIqOhY2jffZZPBC2mv2c4TYnCd2FGQooVu+XkCg+C0EdMl6tBoXNMSVrJNGLZWx2laINXXWpbkGVjXNmqUJrKsQHoeBa7Ys5TK+cwHc9cKzBqxRszr2o5eUjsLncFDha89JBFpYCbrjQhuXIdAhioA6ZSWBgpDv5F/fMfrkckWSsdSNUzAiMMLExXkTXQKE4HB7psQm3gUSpp89DHtAbkoslIRmvW/fHdW0EoEGnJxoHlZ97LrYlE2OR1BMff5DgTJYtFgjJUE3Qr5q8nvipw0XmnbNsjCEmoCpZTPfhdz2aoYy+MuTgY4G3/EQMPnKu7MGOp0BlqYH5Kx4sVkU7fC3web1PN7SawAGC7vhj1GZud0ouOa38gVJBZWVrtbnTiBtg/Inua0M+fRwUeT2Vflv2SyG3EiMbvj2EY96OpQqqqqcaKMTfz0TIbPelFT5Imu2R8IawnCim7JUEtpvN2gA5wvmr2pv63Nx6wW2V8YYuRK3kIvFXIWBWHqMWV0jqtrgGPXfGv3yUU+u4g+R9EWE6g=="
	
}



# Get the latest Amazon Linux ami id
data "aws_ami" "amazon_linux" {
	most_recent = true

	filter {
	name = "name"
	values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
	}


	owners = ["amazon"]


}
 
# Create ec2 instance
resource "aws_instance" "web" {
	ami = data.aws_ami.amazon_linux.id
	instance_type = "t2.micro"
	key_name = "vladyslavkey"
	vpc_security_group_ids = [aws_security_group.web_sg.id]
	tags = {
	"Name" = "New webserverpoddelskyi"
	}


	user_data = <<-EOF
	#!/bin/bash
	sudo yum update -y
	sudo yum install httpd -y
	sudo systemctl start httpd
	sudo systemctl enable httpd
	echo "<html><h1>Your webserv works!</h1></html>" > /var/www/html/index.html
	EOF
}


# Security group
resource "aws_security_group" "web_sg" {
	name = "Ec2 instance sg"


	ingress {
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["46.150.70.147/32"]
	}


	ingress {
	from_port = 22
 
	to_port =22
	protocol = "tcp"
	cidr_blocks = ["46.150.70.147/32"]
	}


	egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	}
}


output "website_endpoint" {
 value = aws_instance.web.public_dns
}
