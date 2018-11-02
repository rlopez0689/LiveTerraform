# LiveTerraform
Provide a basic infraestructure for multiple stages (staging and prod). Having a remote state on s3, a lock on dynamo db and a module source from a github repo.

![Infraestructure diagram](https://s3.amazonaws.com/myimagesrl/Web+App+Reference+Architecture+(4).png)

## Summary of the infraestructure
* S3 Bucket with versioning enabled for managing the terraform state
* DynamoDB for locking the state
* For each env:
  * A VPC
  * 4 subnets, 2 private(for rds) and 2 public(for ec2)
  * One MySQL RDS with subnet group
  * One webserver cluster with autoscaling group for ec2 and route3 entry for personal domain

## Terraform source module
```
https://github.com/rodrigolopez0689/TerraformModules
```

## Prerequisites

This two environment variables are needed:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

## Automating the infraestructure
There is a makefile for spinning the whole infraestructure
Just fill the variables in the file

* DYNAMO_LOCK_DB
* DB_PASSWORD
* ZONE_ID
* DOMAIN_NAME

And then you can run the makefile:
```
make webcluster
```

Or you can do it manually with the next steps:

### Create S3 bucket for remote state
```
cd global/s3
terraform init
terraform apply -var 'buket_name=YOURBUCKETNAME'
```

### Create DynamoDB for locking the state
```
cd global/dynamo
terraform init
terraform apply -var 'dynamo_table_name=YOURDYNAMONAME'
```

### Create network
```
cd stage/network
terraform init -backend-config="bucket=YOURBUCKETNAME" -backend-config="dynamodb_table=YOURDYNAMONAME"
terraform apply
```

### Create RDS-Mysql
```
cd stage/data-stores/mysql
terraform init -backend-config="bucket=YOUREBUCKETNAME" -backend-config="dynamodb_table=YOURDYNAMONAME"
terraform apply -auto-approve -var 'db_password=PASSWORDDB' -var 'bucket_name=YOURBUCKETNAME'
```

### Create web-server-cluster
```
cd stage/services/webserver-cluster
terraform init -backend-config="bucket=YOURBUCKETNAME" -backend-config="dynamodb_table=YOURDYNAMONAME"
terraform apply -auto-approve -var 'bucket_name=YOURBUCKETNAME' -var 'zone_id=YOURZONEID -var 'domain_name=YOURDOMAINNAME'
```
