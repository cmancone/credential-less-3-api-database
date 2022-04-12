resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu_for_bastion_host.id
  instance_type               = "t2.micro"
  user_data                   = data.template_file.bastion_init.rendered
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = var.bastion_subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion.name

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = local.bastion_tags
}

data "template_file" "bastion_init" {
  template = file("${path.module}/bastion_init.sh")

  vars = {
    akeyless_ca_public_key = var.akeyless_ca_public_key
  }
}

data "aws_ami" "ubuntu_for_bastion_host" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_iam_role" "bastion" {
  name               = local.bastion_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = local.bastion_tags

}

resource "aws_iam_instance_profile" "bastion" {
  name = local.bastion_name
  path = "/"
  role = aws_iam_role.bastion.name
}

data "aws_partition" "current" {}
resource "aws_iam_role_policy_attachment" "SSM-role-policy-attach" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
