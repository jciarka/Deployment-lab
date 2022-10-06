#!/bin/bash

ansible-playbook build-prepare.yaml 
ansible-playbook deploy_db.yaml
ansible-playbook configure_master_slave.yaml
ansible-playbook deploy-backend.yaml 
ansible-playbook deploy-front.yaml 

