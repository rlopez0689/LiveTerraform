output "address" {
      value = "${aws_db_instance.weatherdb.address}"
}
output "port" {
      value = "${aws_db_instance.weatherdb.port}"
}
output "name" {
      value = "${aws_db_instance.weatherdb.name}"
}
output "username" {
      value = "${aws_db_instance.weatherdb.username}"
}
output "password" {
      value = "${aws_db_instance.weatherdb.password}"
      sensitive = true
}
output "engine" {
      value = "${aws_db_instance.weatherdb.engine}"
}
