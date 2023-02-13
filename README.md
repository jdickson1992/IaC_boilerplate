## What does it do? 🔎
This repo will create a full `Infrastructure as Code` (IaC) environment, from **provisioning** to **deployment** using:

- `Terraform` to provision resources on the cloud
- `Ansible` to setup infra on the cloud and initialise the **Docker Swarm** cluster
- `Ansible` to deploy the docker stacks on the cloud infra.

---

## Prerequisites 🔐

-  `Ansible`   **>=2.8**
-  `Terraform` **>=0.12**

Access to a cloud provider account (This has only been tested on **AWS**)

> ⚠️ You will need to get programmatic access keys from AWS which have permissions to configure infra using Terraform

---

## Useful commands

```bash
ansible docker-nodes -m ping -i inventory.ini
```

Drop a publc key file inside `${PWD}/roles/create-user/files`


## Docker contexts

Create and use context to target remote host:

```bash
docker context create remote --docker "host=ssh://james@..."
```

```bash
docker context ls
```

```bash
docker --context remote ps
```

```bash
docker context use remote
```

```bash
docker service create --replicas 3 --name nginx3nodes nginx
```



List nodes:

```bash
docker node ls --format "{{.Hostname}}"
```


```bash
docker node update --label-add deployment=green swarm-manager-0
```

```bash
docker node update --label-add deployment=blue swarm-worker-3
```

To filter by label:

`docker node ls --filter node.label=deployment=blue`



```bash
ssh -i test.pem $(terraform output swarm_manager_public_ip | tr -d '"') docker node ls
```

```
alias terraform_ssh="ssh -i test.pem $(terraform output swarm_manager_public_ip | tr -d '"')"
```


```
terraform_ssh docker service update --env-add ACTIVE_BACKEND=blue-app --env-add BACKUP_BACKEND=green-app swarm_nginx
```
