output "vpc_id"{
    value = "${aws_vpc.prod-vpc.id}"
}

output "public_subnets"{
    value = "${slice(aws_subnet.subnets.*.id, 2, 4)}"
}
output "private_subnets"{
    value = "${slice(aws_subnet.subnets.*.id, 0, 2)}"
}

output "public_subnets_cidr"{
    value = "${slice(aws_subnet.subnets.*.cidr_block, 2, 4)}"
}
