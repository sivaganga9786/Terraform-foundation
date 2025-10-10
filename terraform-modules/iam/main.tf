# # Create IAM role
# resource "aws_iam_role" "this" {
#   name               = var.role_name
#   assume_role_policy = var.assume_role_policy
# }

# # Attach AWS managed policies
# resource "aws_iam_role_policy_attachment" "managed" {
#   for_each   = toset(var.managed_policy_arns)
#   role       = aws_iam_role.this.name
#   policy_arn = each.value
# }

# # Default "full access" inline policy covering all AWS services
# resource "aws_iam_role_policy" "full_access_inline" {
#   count  = var.full_access_default ? 1 : 0
#   name   = "${var.role_name}-full-access"
#   role   = aws_iam_role.this.name
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "*"
#         Resource = "*"
#       }
#     ]
#   })
# }

# # Extra inline policies per project
# resource "aws_iam_role_policy" "extra_inline" {
#   for_each = var.extra_inline_policies
#   name     = each.key
#   role     = aws_iam_role.this.name
#   policy   = each.value
# }

# # Create instance profile
# resource "aws_iam_instance_profile" "this" {
#   name = "${var.role_name}-instance-profile"
#   role = aws_iam_role.this.name
# }


# -------------------------------
# Create IAM Role
# -------------------------------
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

# -------------------------------
# Attach AWS Managed Policies
# -------------------------------
resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# -------------------------------
# Create Custom Managed Policies
# -------------------------------
resource "aws_iam_policy" "custom" {
  for_each   = var.custom_managed_policies
  name       = each.key
  policy     = each.value
  description = "Custom managed policy created via reusable module"
}

# Attach custom managed policies
resource "aws_iam_role_policy_attachment" "custom_attach" {
  for_each   = aws_iam_policy.custom
  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
}

# -------------------------------
# Extra Inline Policies
# -------------------------------
resource "aws_iam_role_policy" "extra_inline" {
  for_each = var.extra_inline_policies
  name     = each.key
  role     = aws_iam_role.this.name
  policy   = each.value
}

# -------------------------------
# Create Instance Profile for EC2
# -------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
}
