output "address" {
      value = "${aws_db_instance.example.address}"
}
output "port" {
      value = "${aws_db_instance.example.port}"
}
output "vpc_id" {
    value = "${aws_vpc.prod-vpc.id}"
}
output "vpc_cidr_block" {
    value = "${aws_vpc.prod-vpc.cidr_block}"
}
