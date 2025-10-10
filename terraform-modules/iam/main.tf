# Create IAM role
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Create custom managed policies
resource "aws_iam_policy" "custom" {
  for_each   = var.custom_managed_policies
  name       = each.key
  policy     = each.value
}

# Attach custom managed policies
resource "aws_iam_role_policy_attachment" "custom_attach" {
  for_each   = var.custom_managed_policies
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[each.key].arn
}

# Extra inline policies per project
resource "aws_iam_role_policy" "extra_inline" {
  for_each = var.extra_inline_policies
  name     = each.key
  role     = aws_iam_role.this.name
  policy   = each.value
}

# Create instance profile for EC2
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
}
