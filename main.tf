terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "blackboard_instance" {
  ami           = "ami-0d47884a405e8643e"
  instance_type = "t2.large"

  tags = {
    Name = "BlackboardInstance"
  }

  vpc_security_group_ids = ["sg-0ff6121c3e0ced2c0"]
  subnet_id = "subnet-04598b2a29dc24a3c"

  key_name = "bblearn-keypair"
}

resource "aws_ec2_instance_state" "blackboard_instance" {
  instance_id = aws_instance.blackboard_instance.id
  state       = "running" # "stopped" or "running"
}

output "blackboard_public_dns" {
  description = "The URL to access Blackboard from the browser"
  value = "https://${aws_instance.blackboard_instance.public_dns}"
}

output "blackboard_username" {
  description = "The username for logging into Blackboard from the browser"
  value = "administrator"
}

output "blackboard_password" {
  description = "The password for logging into Blackboard from the browser"
  value = aws_instance.blackboard_instance.id
}

output "ssh_command" {
  description = "The command to SSH into the Blackboard instance"
  value = "ssh -i ~/.ssh/bblearn-aws ubuntu@${aws_instance.blackboard_instance.public_dns}"
}