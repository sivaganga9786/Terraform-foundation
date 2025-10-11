# resource "aws_instance" "ec2" {
#   count         = length(var.instances)
#   ami           = var.instances[count.index].ami
#   instance_type = var.instances[count.index].instance_type
#   subnet_id     = var.subnet_id
#   associate_public_ip_address = true
#   user_data     = element(var.user_data, count.index)
#   security_groups        = [aws_security_group.ec2_sg.id]
#   key_name      = var.key_name
#   # Increase root volume size to 20 GB
#   root_block_device {
#     volume_size = var.volume_size              # Size in GB
#     volume_type = "gp2"             # General Purpose SSD (can be gp3, io1, etc.)
#     delete_on_termination = true
#   }
#   tags = {
#     Name = var.instances[count.index].name
#   }
# }


resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data

  tags = merge(
    {
      Name = "${var.project_name}-${var.role}"
      Role = var.role
    },
    var.tags
  )
}
