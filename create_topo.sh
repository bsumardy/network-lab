#!/bin/bash

containerlab destroy -t containerlab/topo.clab.yaml
containerlab deploy -t containerlab/topo.clab.yaml
ansible-playbook -i ansible/inventory.yml ansible/inject-unique-id.yml
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
ansible-playbook -i ansible/inventory.yml ansible/push-frr.yml