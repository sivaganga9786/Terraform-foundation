# === EC2 IAM Role and Profile for SSM ===
resource "aws_iam_role" "ec2_ssm_role" {
  name               = "${var.name_prefix}-ec2-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# === Security Group ===
resource "aws_security_group" "ec2_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for instances (no SSH inbound by default)"
  vpc_id      = var.vpc_id

  # Allow all outbound for SSM communications
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.name_prefix}-sg" }, var.tags)
}

# === EC2 Instance ===
resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/user_data.tpl", {
    hostname = var.instance_name
  })

  tags = merge({
    Name = var.instance_name
  }, var.tags)
}

# === IAM Policy for your AWS CLI User or Role to allow SSM session start ===
resource "aws_iam_policy" "ssm_session_management_policy" {
  name        = "${var.name_prefix}-ssm-session-policy"
  description = "Allow SSM session start and management for CLI user/role"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeSessions",
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Resource = "*"
      }
    ]
  })
}

# === Attach policy to CLI IAM user ===
resource "aws_iam_user_policy_attachment" "attach_ssm_session_policy" {
  user       = var.cli_user_name
  policy_arn = aws_iam_policy.ssm_session_management_policy.arn
}

# If you want to attach to an IAM Role instead of user, uncomment this and provide var.cli_role_name
resource "aws_iam_role_policy_attachment" "attach_ssm_session_policy_role" {
  role       = var.cli_role_name
  policy_arn = aws_iam_policy.ssm_session_management_policy.arn
}




# # EC2 instance with SSM instance profile and minimal SG (no SSH open)
# resource "aws_iam_role" "ec2_ssm_role" {
#   name               = "${var.name_prefix}-ec2-ssm-role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
# }

# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "ssm_attach" {
#   role       = aws_iam_role.ec2_ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "${var.name_prefix}-ec2-profile"
#   role = aws_iam_role.ec2_ssm_role.name
# }

# resource "aws_security_group" "ec2_sg" {
#   name        = "${var.name_prefix}-sg"
#   description = "Security group for instances (no SSH inbound by default)"
#   vpc_id      = var.vpc_id

#   # Egress: allow all outbound so SSM can communicate to AWS endpoints
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge({ Name = "${var.name_prefix}-sg" }, var.tags)
# }

# resource "aws_instance" "this" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = var.subnet_id
#   iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]
#   associate_public_ip_address = false

#   user_data = templatefile("${path.module}/user_data.tpl", {
#     hostname = var.instance_name
#   })

#   tags = merge({
#     Name = var.instance_name
#   }, var.tags)
# }

