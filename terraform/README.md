# Tarrform

## Directory Strructure

```
terraform/
  ├── 01-network/          # VPC, Subnet, Routing
  ├── 02-security/         # IAM, ACM, SSM
  ├── 03-database/         # RDS
  ├── 04-platform/         # ECR, ECS Cluster
  ├── 05-application/      # ECS Service/Task, ALB
  └── README.md
```

## How to apply

If you want to give the vars from outside, you can assign values directly to variable names in files with a .tfvars or .auto.tfvars extension.
https://developer.hashicorp.com/terraform/language/parameterize#variable-definition-files

Also, you can set environment variables using the `TF_VAR_` prefix to a variable name.
https://developer.hashicorp.com/terraform/language/parameterize#environment-variables

```
cp sample-set_variables.sh set_variables.sh
vim set_variables.sh

cd 01-network/
source ../set_variables.sh && terraform plan
source ../set_variables.sh && terraform apply

cd 02-security/
source ../set_variables.sh && terraform plan
source ../set_variables.sh && terraform apply

cd 03-database/
source ../set_variables.sh && terraform plan
source ../set_variables.sh && terraform apply

cd 04-platform/
source ../set_variables.sh && terraform plan
source ../set_variables.sh && terraform apply


cd 05-application/
source ../set_variables.sh && terraform plan
source ../set_variables.sh && terraform apply
```

## Tips

### How to chek the state of already created resources

```
terraform state list
terraform state show ${resourceType.resourceName}
terraform state list | xargs -I% terraform state show %
```

### How to check the master key

1. Case1: check from the file

   ```
   cat config/master.key
   ```

2. Case2: check from the rails console

   ```
   rails console
   > Rails.application.credentials.secret_key_base
   ```
