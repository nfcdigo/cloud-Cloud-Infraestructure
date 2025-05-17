resource "aws_vpc" "minha_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc-calheon"
  }
}

##Cria subnet privada na us-east-1a
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "priv_subnet_1a"
  }
}

##Cria a tabela de rota da subnet privada 1a
resource "aws_route_table" "priv_rt_1a" {
  vpc_id = aws_vpc.minha_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "priv_rt_1a"
  }
}

## Associa a tabela de rota priv_rt com a subnet privada priv-subnet-1a
resource "aws_route_table_association" "priv_1a_associate" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.priv_rt_1a.id
}

## Cria subnet publica na us-east-1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub-subnet-1a"
  }
}

##Cria a tabela de rota da subnet publica 1a
resource "aws_route_table" "public_rt_1a" {
  vpc_id = aws_vpc.minha_vpc.id
    
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  

  tags = {
    Name = "pub_rt_1a"
  }
}

## Associa a tabela de rota pub_rt_1a com a subnet publica pub-subnet-1a
resource "aws_route_table_association" "pub_1a_associate" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public_rt_1a.id
}


## Cria um internet gatway na vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minha_vpc.id

  tags = {
    Name = "igw-tf-vpc-automation"
  }
}


## Cria um IP publico para o natgatway
resource "aws_eip" "nat_gw_ip" {
  domain           = "vpc"
}


## Cria um nat gatway utilizando um ip publico
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_gw_ip.id
  subnet_id     = aws_subnet.public-subnet-1a.id

  tags = {
    Name = "nat-gw-1a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


## Cria subnet privada na us-east-1b
resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "priv_subnet_1b"
  }
}


##Cria a tabela de rota da subnet privada 1b
resource "aws_route_table" "priv_rt_1b" {
  vpc_id = aws_vpc.minha_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1b.id
  }

  tags = {
    Name = "priv_rt_1b"
  }
}


## Associa a tabela de rota priv_rt com a subnet privada priv-subnet-1a
resource "aws_route_table_association" "priv_1b_associate" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.priv_rt_1b.id
}


## Cria subnet publica na us-east-1a
resource "aws_subnet" "public-subnet-1b" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.200.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pub-subnet-1b"
  }
}


## Associa a tabela de rota pub_rt_1a com a subnet publica pub-subnet-1a
resource "aws_route_table_association" "pub_1b_associate" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public_rt_1a.id
}

## Cria um ip publico para o natgatway
resource "aws_eip" "nat_gw_ip_1b" {
  domain           = "vpc"
}


## Cria um nat gatway utilizando um ip publico
resource "aws_nat_gateway" "nat_gw_1b" {
  allocation_id = aws_eip.nat_gw_ip_1b.id
  subnet_id     = aws_subnet.public-subnet-1b.id

  tags = {
    Name = "nat-gw-1b"
  }
  
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}