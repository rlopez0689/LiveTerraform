output "vpc_id"{
    value = "${aws_vpc.stage-vpc.id}"
}

output "public_subnets"{
    value = "${slice(aws_subnet.subnets.*.id, 2, 4)}"
}
output "private_subnets"{
    value = "${slice(aws_subnet.subnets.*.id, 0, 2)}"
}
