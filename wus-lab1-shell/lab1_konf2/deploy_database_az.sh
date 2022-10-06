#!/bin/bash

base=$(cat config | grep database)
base_a=($base)

echo "installing mysql..."
az vm run-command invoke -g ${base_a[5]} -n ${base_a[6]} --command-id RunShellScript \
    --scripts @set_up_db_local.sh
