# Smallest cidr block in AWS is /28 - See https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing
# This gives a /27 each for public and private
# Then further divided into the number of availability zones
cidr_block = "172.16.0.0/26"