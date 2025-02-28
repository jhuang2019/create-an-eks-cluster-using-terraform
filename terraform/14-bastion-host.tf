data "aws_ami" "amazon-linux-2-bastion" {
 most_recent = true
 filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 owners = ["137112412989"] # AWS
}

resource "aws_security_group" "eks_bastion_sg" {
  vpc_id = aws_vpc.eks_test_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "EKS Bastion host Security Group"
    Terraform   = "true"
    } 
}


# CREATE BASTION HOST IN PUBLIC SUBNET

resource "aws_instance" "bastion_host-1a" {
  ami = data.aws_ami.amazon-linux-2-bastion.id
  iam_instance_profile = aws_iam_instance_profile.bastion_host.name
  instance_type = "t2.micro"
  key_name = aws_key_pair.eks_public_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.eks_bastion_sg.id]
  subnet_id = aws_subnet.public_2a.id
  tags = {
    Name = "EKS Bastion Host - public subnet 1A"
  }
}


resource "aws_iam_role" "bastion_host_role" {
  name = "bastion-host-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "bastionhost-AmazonEC2SSM" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_host_role.name
}


resource "aws_iam_instance_profile" "bastion_host" {
  name = "bastion_host_instance_profile"
  path = "/"
  role = aws_iam_role.bastion_host_role.name
}