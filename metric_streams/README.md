# Metric Streams Configuration

Terraform を使用して New Relic One へ Metric Stream で CloudWatch のメトリクスを転送する設定になります。

## Set up

```variables.tf
variable "newrelic_license_key" {
  type    = string
  default = <Set your New Relic One License Key>
}

# S3 の bucket 名を一意のものにするために prefix を設定しています。
variable "bucket_prefix" {
  type    = string
  default = <Set bucket prefix>
}

```

## Run Terraform Command

```shell
# init terraform project
terraform init

# dry-run
terraform plan

# apply
terraform apply
```
