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
	access_key = "ASIAZI2LHHY3IAYX26ON"
	secret_key = "rxFYyogTrqnTTD5q7VR8Wr9/tksV/dBeTfqgjnO1"
	token = "IQoJb3JpZ2luX2VjELH//////////wEaCXVzLXdlc3QtMiJIMEYCIQClLf4y2Dtxg6N2T4yMtSMMCYY3GhDAszjtiToqmFsRyQIhAJn599WZj0jiC5me3QVscqXs4G2fRCX0G9IspKxwr6DRKq0CCEoQABoMNjM3NDIzNTMzNjIyIgw69PAydDZ6WnmES2wqigIbCiOidjUGoCno1wIBESs32dt0RqG5D5uqpAjep88PJcxVQtlVZlGL0E6iEH2Q6Hm/Gz8E3XKjjPKrgL8HSCqjEy7Y2U61Y7frGevqzox2PpEiZuHmFVZnFhWkhbq5l7VkrScTuaGuucd46AiOoCQ/ByZjAjD+9yn07XWFmOIDScRs4TOPJK15+hHZAyPlmPpv4gRSZx8dvqI972tacxnMxC/I71B5SrD8TBcLzBYEa4aEj53qm0bIj1GBuhZKoDVp3HouoZbCALhlDwXmwb6RZJkrNj3t9ulbxB6mKai9h+A3i0x42srzTjsUPp1Qv9dJQTWTDFTH3QdvtwSC4WshARaBTHfBBU7+ojDQ1ZyzBjqcAVOHJLI5btoU0mEKjz2mxeR4PoJRND/pPuFzArz9RaUDBB61aTpxzi8GkOAFPgPtSuHRphdP7AvCaqlidwnppYh1OkkVha2y/zcjT2kPDmkj0Oday6NHb8RXXjuZjCKgOaG6TFQA69qB/DvMzQcvJg0Qdxtgi56DidDSAYv3UYygbaCMHiDcs5937Hg7qT9DlBzM9//aK44AEhoHEg=="
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
