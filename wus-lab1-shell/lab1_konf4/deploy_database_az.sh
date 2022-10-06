#!/bin/bash

database=$(cat config | grep database)
database_a=($database)



echo "installing database..."
az vm run-command invoke -g ${database_a[5]} -n ${database_a[6]} --command-id RunShellScript \
    --scripts @set_up_db_local.sh

# kopiowanie danych z mastera do slave
scp boot_master_slave.sh ${database_a[7]}@${database_a[1]}:/etc/init.d/mysqld_multi


echo "configure database..."
az vm run-command invoke -g ${database_a[5]} -n ${database_a[6]} --command-id RunShellScript \
    --scripts @set_up_db_local_slave.sh