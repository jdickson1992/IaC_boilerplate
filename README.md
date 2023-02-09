# IaC_boilerplate
Terraform + Ansible + Docker Swarm Boilerplate

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