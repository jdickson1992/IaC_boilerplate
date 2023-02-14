#!/bin/bash

managers=$(docker node ls --format "{{.Hostname}}" | grep 'manager')
for node in $managers; do
  docker node update --label-add type=manager $node
done

workers=$(docker node ls --format "{{.Hostname}}" | grep 'worker')
for node in $workers; do
  docker node update --label-add type=worker $node
done

# Get the number of worker nodes in the swarm
nodes=$(docker node ls --filter node.label=type=worker --format "{{.Hostname}}"| wc -l)

# Divide the nodes between green_nodes and blue_nodes
if (( nodes % 2 == 0 )); then
  green_nodes=$((nodes / 2))
  blue_nodes=$((nodes / 2))
else
  green_nodes=$((nodes / 2 + 1))
  blue_nodes=$((nodes / 2))
fi

# Add the label to the green nodes
counter=0
for node in $(docker node ls --format "{{.Hostname}}" --filter node.label=type=worker); do
  if (( counter < green_nodes )); then
    docker node update --label-add deployment=green $node
  else
    docker node update --label-add deployment=blue $node
  fi
  ((counter++))
done


