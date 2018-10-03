# LiveTerraform
Provide a basic infraestructure for multiple stages (staging and prod). Having a remote state on s3, a lock on dynamo db and a module source from a github repo.

![Infraestructure diagram](https://s3.amazonaws.com/myimagesrl/Web+App+Reference+Architecture+(4).png)

## Terraform source module
```
https://github.com/rodrigolopez0689/TerraformModules
```

## Prerequisites

This two environment variables are needed:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

### Create S3 bucket for remote state
```
cd global/s3
terraform init
terraform plan
terraform apply
```

### Create DynamoDB for locking the state
```
cd global/dynamo
terraform init
terraform plan
terraform apply
```

### Create RDS-Mysql
```
cd stage/data-stores/mysql
terraform init
terraform plan
terraform apply
```

### Create web-server-cluster
```
cd stage/services/webserver-cluster
terraform init
terraform plan
terraform apply
It should output the dns of the load balancer.
```
