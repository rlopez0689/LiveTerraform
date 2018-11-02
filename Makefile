S3_DIR=global/s3
DYNAMO_DIR=global/dynamo
NETWORK_DIR=stage/network/
MYSQL_DIR=stage/data-stores/mysql
WEBCLUSTER_DIR=stage/services/webserver-cluster

S3_BUCKET=
DYNAMO_LOCK_DB=
DB_PASSWORD=
ZONE_ID=
DOMAIN_NAME=

s3:
	@echo Creating S3 bucket for remote state...
	cd $(S3_DIR) && terraform init
	cd $(S3_DIR) && terraform apply -auto-approve -var 'bucket_name=$(S3_BUCKET)'

dynamo: s3
	@echo Creating DynamoDB for locking the state...
	cd $(DYNAMO_DIR) && terraform init
	cd $(DYNAMO_DIR) && terraform apply -auto-approve  -var 'dynamo_table_name=$(DYNAMO_LOCK_DB)' 

network: dynamo
	@echo Creating network infraestructure...
	cd $(NETWORK_DIR) && terraform init -backend-config="bucket=$(S3_BUCKET)" -backend-config="dynamodb_table=$(DYNAMO_LOCK_DB)" -reconfigure
	cd $(NETWORK_DIR) && terraform apply -auto-approve 

mysql: network
	@echo Creating RDS-Mysql...
	cd $(MYSQL_DIR) && terraform init -backend-config="bucket=$(S3_BUCKET)" -backend-config="dynamodb_table=$(DYNAMO_LOCK_DB)" -reconfigure
	cd $(MYSQL_DIR) && terraform apply -auto-approve -var 'db_password=$(DB_PASSWORD)' -var 'bucket_name=$(S3_BUCKET)' 

webcluster: mysql
	@echo Create web-server-cluster...
	cd $(WEBCLUSTER_DIR) && terraform init -backend-config="bucket=$(S3_BUCKET)" -backend-config="dynamodb_table=$(DYNAMO_LOCK_DB)" -reconfigure
	cd $(WEBCLUSTER_DIR) && terraform apply -auto-approve -var 'bucket_name=$(S3_BUCKET)' -var 'zone_id=$(ZONE_ID)' -var 'domain_name=$(DOMAIN_NAME)'

destroy: destroy_mysql
	cd $(NETWORK_DIR) && terraform destroy -auto-approve

destroy_mysql: destroy_webcluster
	cd $(MYSQL_DIR) && terraform destroy -auto-approve -var 'db_password=$(DB_PASSWORD)' -var 'bucket_name=$(S3_BUCKET)'

destroy_webcluster:
	cd $(WEBCLUSTER_DIR) && terraform destroy -auto-approve -var 'bucket_name=$(S3_BUCKET)' -var 'zone_id=$(ZONE_ID)' -var 'domain_name=$(DOMAIN_NAME)'

.DEFAULT_GOAL := webcluster
