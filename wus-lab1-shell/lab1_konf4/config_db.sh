
    sudo chmod +x /etc/init.d/mysqld_multi
    sudo update-rc.d mysqld_multi defaults



    sudo sed -i 's/#log_bin/log_bin/g' /etc/mysql/mysql1.conf.d/mysqld.cnf
    sudo 'innodb_flush_log_at_trx_commit  = 1' > /etc/mysql/mysql1.conf.d/mysqld.cnf
    sudo 'sync_binlog                 = 1' > /etc/mysql/mysql1.conf.d/mysqld.cnf    
    sudo 'binlog-format               = ROW' > /etc/mysql/mysql1.conf.d/mysqld.cnf



    sudo mysqld_multi stop 1
    sudo mysqld_multi start 1


    sudo mysql -uroot -p --host=127.0.0.1 --port=3306 -e "CREATE USER 'replication'@'%' IDENTIFIED BY 'replication'"
    sudo mysql -uroot -p --host=127.0.0.1 --port=3306 -e "GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%'"


    mysqldump -uroot -p --host=127.0.0.1 --port=3306 --all-databases --master-data=2 > replicationdump.sql
    mysql -uroot -p --host=127.0.0.1 --port=3307 < replicationdump.sql

    mysql -uroot -p --host=127.0.0.1 --port=3307 -e "CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_USER='replication', MASTER_PASSWORD='replication', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=349;"
    mysql -uroot -p --host=127.0.0.1 --port=3307 -e "START SLAVE"

