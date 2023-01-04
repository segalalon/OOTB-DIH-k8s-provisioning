variable "vpc_cidr" {}
variable "subnets" {}

resource "aws_vpc" "primary" {
  cidr_block = var.vpc_cidr

  tags = tomap({
    "Name"                                        = "${local.primary.name}-vpc",
    "kubernetes.io/cluster/${local.primary.name}" = "shared",
  })
}

resource "aws_subnet" "primary" {
  count                   = length(var.subnets)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.primary.id

  tags = tomap({
    "Name"                                        = "${local.primary.name}-subnet.${count.index + 1}",
    "kubernetes.io/cluster/${local.primary.name}" = "shared",
    "kubernetes.io/role/elb"                      = "1",
  })
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "${local.primary.name}-igw"
  }
}

resource "aws_route_table" "primary" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
}

resource "aws_route_table_association" "primary" {
  count = length(var.subnets)

  subnet_id      = aws_subnet.primary.*.id[count.index]
  route_table_id = aws_route_table.primary.id
}

output "vpc_id_primary" {
  value = aws_vpc.primary.id
}
