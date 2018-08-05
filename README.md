# mongoaws

This repository contains set of Terraform and Ansible scripts 
to setup infrastructure to run multinode mongo db replica set on top of aws infrastructure.
### current features:
* create missing aws infrastructure:
  * SecurityGroup
  * Instances with external block storage
  * Route53 records
* provision created instances and deploy custom docker image 
* initialise mongodb replica-set

## PreRequisites:


have pre-installed 
* terraform
* ansible

have pre-configured resources in amazon:
* vpc
* subnets
* hosted private DNS zone in Route53 linked to vpc. 
    

## Usage: 
* clone repository to your system and and change directory to cloned repo
```
git clone https://github.com/pupska/mongoaws
cd mongoaws
```
* Fill variables.tf according to your environment. 
* start deploy 
```
terraform init
terraform apply
```
* Now you can connect to any of output IPs with your favorite mongodb client and check with rs.config() that replicaset is configured. 

* after you complete with it, destroy cluster to save resources
```
terraform destroy
```

# mongodb docker image
During deploy where used custom docker image 
https://hub.docker.com/r/vbobyr/aws_mongo_rs/

It's dockerfile available in docker folder. Feel free to rebuild if you need any extra customisations
