resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = var.assume_role_policy
}

# Attach managed policy (AmazonEC2RoleforSSM)
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}

# Create instance profile
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
}
