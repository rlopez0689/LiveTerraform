output "address" {
      value = "${aws_db_instance.example.address}"
}
output "port" {
      value = "${aws_db_instance.example.port}"
}
output "vpc_id" {
    value = "${aws_vpc.stage-vpc.id}"
}
output "vpc_cidr_block" {
    value = "${aws_vpc.stage-vpc.cidr_block}"
}
