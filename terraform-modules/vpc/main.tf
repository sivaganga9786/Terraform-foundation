resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  #availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  # tags = {
  #   Name  = "${var.cluster_name}-private-${count.index + 1}"
  #   Role = count.index < 2 ? "app" : "db"   # first 2 = app, next 2 = db
  #  }
  tags = {
      Name = count.index < 2 ? "${var.cluster_name}-app-tier-${count.index + 1}" : "${var.cluster_name}-db-tier-${count.index - 1}"
      Role = count.index < 2 ? "app-tier" : "db-tier"
    }
}


resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  map_public_ip_on_launch = true

  tags = {
     Name   = "${var.cluster_name}-web-tier-${count.index + 1}"
 }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
   Name = "${var.cluster_name}-igw"
  }
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
     Name = "${var.cluster_name}-nat-${count.index + 1}"
   }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

   tags = {
     Name = "${var.cluster_name}-nat-${count.index + 1}"
   }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
     Name = "${var.cluster_name}-public"
   }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
   # nat_gateway_id = aws_nat_gateway.main[count.index].id
    nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id

  }

  tags = {
    Name = "${var.cluster_name}-private-${count.index + 1}"
   }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  #route_table_id = aws_route_table.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
