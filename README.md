## What does it do? 🔎
This repo will create a full `Infrastructure as Code` (IaC) environment, from **provisioning** to **deployment** using:

- `Terraform` to provision resources on the cloud 🌎
- `Ansible` to setup infra on the cloud and initialise the **Docker Swarm** cluster 💻
- `Ansible` to deploy the docker stacks on the cloud infra 🐳

## Prerequisites 🔐

-  `Ansible`   **>=2.8**
-  `Terraform` **>=0.12**
-  `aws cli`

Access to a cloud provider account (This has only been tested on **AWS**)

> ⚠️ You will need to get programmatic access keys from AWS which have permissions to configure infra using Terraform.
>
> Follow this [link](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) to retreive an access key.

When the above step has been completed, configure the credentials and associate them with a profile:

```bash
aws configure --profile terraform
AWS Access Key ID [None]: <enter the access key>
AWS Secret Access Key [None]: <enter the secret key>
Default region name [None]: <us-east-1>
Default output format [None]: <None>
```

Then set the `AWS_PROFILE` to be active in your current shell.

```bash
export AWS_PROFILE=terraform
```

You should now have permissions to provision resources via terraform 🚀

## Getting Started 🎬

Clone the repo and cd into the directory:

```bash
git clone git@github.com:jdickson1992/IaC_boilerplate.git && cd IaC_boilerplate
```

Execute the bash script `./deploy.sh`:

This script will present you with 3 options **[Enter the number associated with the option]**

  1. **full_iac** *[recommended]*
     1. Will provision the cloud infra & initiate a docker swarm cluster.
     2. A simple docker stack should be deployed to confirm the cluster is operational

  2. **delete_swarm** 
     1. Forces all nodes to leave swarm


  3. **destroy_iac**
     1. Destroys all infra created via terraform.
     2. **Run this when finished testing**.


## Blue-green deployments 🔵🟢

The script `./switch_traffic.sh` can be used to illustrate how **traffic is switched** between the blue and green applications.

Under the covers this is just running a *docker service update* command, something akin to:

```
docker service update --env-add ACTIVE_BACKEND=green-app --env-add BACKUP_BACKEND=blue-app swarm_nginx
```


## Finished 🔚

Execute the bash script `deploy.sh` again. 

Specify option `3`.

This will destroy everything Terraform created.

![image](https://user-images.githubusercontent.com/47530786/218748579-ea7d6797-4d18-4b94-8966-8d6f82d0eb04.png)






