resource "aws_iam_role" "instance_role" {
  name_prefix        = var.app_name
  tags = merge(var.tags, {Name = "bsc-archive-node"})
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
}

resource "aws_iam_instance_profile" "bsc-archive" {
  name_prefix = var.app_name
  role        = aws_iam_role.instance_role.name
}

data "aws_iam_policy_document" "sumo-ssm-parmas" {
  ### maybe you needed access to your parameters
  statement {
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = [
    "*"]
  }
  statement {
    actions = [
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.this.account_id}:parameter/${trim(var.sumo_key_ssm_path, "/")}",
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.this.account_id}:parameter/${trim(var.sumo_id_ssm_path, "/")}"
    ]
  }
}

resource "aws_iam_policy" "sumo_api_key_profile" {
  count       = var.sumo_key_ssm_path != "" ? 1 : 0
  name_prefix = "sumossm"
  policy      = data.aws_iam_policy_document.sumo-ssm-parmas.json
}

resource "aws_iam_role_policy_attachment" "sumo_ssm_param" {
  count      = var.sumo_key_ssm_path != "" ? 1 : 0
  role       = aws_iam_role.instance_role.id
  policy_arn = aws_iam_policy.sumo_api_key_profile[0].arn
}
resource "aws_iam_role_policy_attachment" "sumo_ssm_agent" {
  role       = aws_iam_role.instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
###TODO break out the rules into aws_security_group_rule statements each with their own description
resource "aws_security_group" "bsc-node" {
  name_prefix = var.app_name
  description = "ssh + http rpc ports"
  vpc_id      = local.vpc_id
  tags = merge(var.tags, {Name = "bsc-archive-node"})
  ingress {
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "TCP"
    from_port   = 8454
    to_port     = 8454
    cidr_blocks = [local.vpc_cidr]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {create_before_destroy = true}
}

##TODO figure out a way to provide different graphs to userdata, right now this always grabs the badger one
## could accept a list of name/repo tuples and parse a more complex userdata
data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.sh.template")
  vars = {
    sumo_key_ssm_path = var.sumo_key_ssm_path
    sumo_id_ssm_path  = var.sumo_id_ssm_path
    region            = var.region
    ebs_device_name   = "/dev/nvme1n1"
    mount_point       = "/bsc_geth"
  }
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bsc_archive" {
  ami                         = data.aws_ami.amazon-linux.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.bsc-archive.name
  security_groups             = [aws_security_group.bsc-node.id]
  associate_public_ip_address = false
  disable_api_termination     = var.disable_instance_termination
  subnet_id                   = var.private_subnet_ids[0]
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.bsc-node.id]
  user_data                   = data.template_file.userdata.rendered
  key_name                    = var.aws_keypair_name
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = var.datavolume_size
    snapshot_id           = var.ebs_snapshot_id
    delete_on_termination = false
  }
  lifecycle {
    ignore_changes = [ami, security_groups, ]
  }
  tags = merge(var.tags, {Name = "bsc-archive-node"})
}

