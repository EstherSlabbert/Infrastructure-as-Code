# define provider and region
provider "aws" {
	region = "eu-west-1"
}

# VPC setup

# create vpc
resource "aws_vpc" "my_vpc" {
# specify CIDR block
	cidr_block = "10.0.0.0/16"
# name vpc
	tags = {
		Name = "tech230-esther-vpc-terraform"
	}
}

# create internet gateway (igw)
resource "aws_internet_gateway" "igw" {
# link igw to vpc
	vpc_id = aws_vpc.my_vpc.id
# name igw
	tags = {
		Name = "tech230-esther-igw-terraform"
	}
}

# create private subnet within vpc
resource "aws_subnet" "private_subnet" {
# attach subnet to specified vpc
    vpc_id = aws_vpc.my_vpc.id
# specify CIDR block for subnet
    cidr_block = "10.0.3.0/24"
# name subnet
    tags = {
            Name = "tech230-esther-private-subnet-terraform"
    }
}

# create public subnet within vpc
resource "aws_subnet" "public_subnet" {
# attach subnet to specified vpc
    vpc_id = aws_vpc.my_vpc.id
# specify CIDR block for subnet
    cidr_block = "10.0.2.0/24"
# name subnet
    tags = {
            Name = "tech230-esther-public-subnet-terraform"
    }
}

# create public route table
resource "aws_route_table" "public_route_table" {
# link to vpc
	vpc_id = aws_vpc.my_vpc.id
# name route table
	tags = {
		Name = "tech230-esther-public-RT-terraform"
	}
}

# creating route in public route table and associates with igw
resource "aws_route" "public_route" {
# specifies this route table for association with igw
	route_table_id = aws_route_table.public_route_table.id
# routes all traffic to igw
	destination_cidr_block = "0.0.0.0/0"
# specifies association to this igw
	gateway_id = aws_internet_gateway.igw.id
}

# associates public route table with public subnet
resource "aws_route_table_association" "public_subnet_association" {
# specifies subnet to be associated
	subnet_id = aws_subnet.public_subnet.id
# specifies route table to be associated
	route_table_id = aws_route_table.public_route_table.id
}

# Security Groups

# Create security group for web app server
resource "aws_security_group" "tech230-esther-app-server-sg" {
	name        = "tech230-esther-app-server-sg"
	description = "Security group for Sparta Provisioning Test App web server"
	vpc_id      = aws_vpc.my_vpc.id

	# Inbound rule for SSH access from my IP
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		# my ip
		cidr_blocks = ["86.15.46.90/32"]
	}
  
	# Inbound rule for HTTP access from all
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound rule for port 3000 access from all
	ingress {
		from_port   = 3000
		to_port     = 3000
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound rule for MongoDB access from private subnet
	ingress {
		from_port   = 27017
		to_port     = 27017
		protocol    = "tcp"
		# private subnet CIDR block is "10.0.3.0/24"
		cidr_blocks = ["10.0.3.0/24"]
	}

	# Outbound rule allowing all traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Create security group for DB server
resource "aws_security_group" "tech230-esther-db-server-sg" {
	name        = "tech230-esther-db-server-sg"
	description = "Security group for MongoDB server"
	vpc_id      = aws_vpc.my_vpc.id

	# Inbound rule for MongoDB access from app server in public subnet
	ingress {
		from_port        = 27017
		to_port          = 27017
		protocol         = "tcp"
		cidr_blocks = ["10.0.2.0/24"]
	}

	# Outbound rule allowing all traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Launch web app and db EC2 instances from AMIs

# Launch DB server EC2 instance in private subnet
resource "aws_instance" "tech230-esther-db" {
	# ami for db
	ami           = "ami-06c5f4ed7a203bed8"
	instance_type = "t2.micro"
	key_name      = "tech230"
	subnet_id     = aws_subnet.private_subnet.id
	vpc_security_group_ids = [aws_security_group.tech230-esther-db-server-sg.id]

	private_ip    = "10.0.3.100" # specify desired private IP

	tags = {
		Name = "tech230-esther-db"
	}
}

# Launch app server EC2 instance in public subnet
resource "aws_instance" "tech230-esther-web-app" {
	# ami for app
	ami           = "ami-0136ddddd07f0584f"
	instance_type = "t2.micro"
	key_name      = "tech230"
	subnet_id     = aws_subnet.public_subnet.id
	vpc_security_group_ids = [aws_security_group.tech230-esther-app-server-sg.id]
	associate_public_ip_address = true

	depends_on = [aws_instance.tech230-esther-db]

	user_data = <<-EOF
    	#!/bin/bash
    	# Update the sources list and Upgrade any available packages
    	sudo apt update -y && sudo apt upgrade -y

    	# gets sources list that could potentially be needed for the following installations
    	sudo apt update

    	# Installs Nginx
    	sudo apt install nginx -y

		# setup nginx reverse proxy
    	sudo apt install sed
    	# $ and / characters must be escaped by putting a backslash before them
    	sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default
    	# restart nginx to get reverse proxy working
    	sudo systemctl restart nginx

    	# Installs git
    	sudo apt install git -y

    	# sets source to retrieve nodejs
    	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

    	# installs node.js
    	sudo apt install -y nodejs

    	# Enables Nginx to run on start up of API or VM
    	sudo systemctl enable nginx

    	#echo "export DB_HOST=mongodb://10.0.3.100:27017/posts" >> ~/.bashrc
    	#source ~/.bashrc
    	export DB_HOST=mongodb://10.0.3.100:27017/posts

    	# clone repo with app folder into folder called 'repo'
    	git clone https://github.com/daraymonsta/CloudComputingWithAWS repo

    	# install the app (must be after db vm is finished provisioning)
    	cd repo/app
    	npm install

    	# seed database
    	echo "Clearing and seeding database..."
    	node seeds/seed.js
    	echo "  --> Done!"

    	# start the app (could also use 'npm start')

    	# using pm2
    	# install pm2
    	sudo npm install pm2 -g
    	# kill previous app background processes
    	pm2 kill
    	# start the app in the background with pm2
    	pm2 start app.js
	EOF

	tags = {
		Name = "tech230-esther-web-app"
	}
}
