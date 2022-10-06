#!/bin/bash

# if [ -f /etc/init.d/mysql* ]; then
#     echo "mysql installed"
# else 
    # instalacja mysql 
    # sudo apt-get update
    # sudo apt-get install mysql-client -y 
    # sudo apt-get install mysql-server -y 


    # zmiana pliky konfiguracyjnego mysql - możliwe łączenie z zewnątrz hosta
    sudo sed -i 's/mysql.conf.d/mysql1.conf.d/g' /etc/mysql/my.cnf
    sudo '!includedir /etc/mysql/mysq2.conf.d/' > /etc/mysql/my.cnf
    # sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo chown -R testuser /etc/mysql/mysql.conf.d/ 
    sudo cp -a /etc/mysql/mysql.conf.d/ /etc/mysql/mysql1.conf.d/
    sudo cp -a /etc/mysql/mysql.conf.d/ /etc/mysql/mysql2.conf.d/

    sudo sed -i 's/#server-id               = 1/server-id              = 1/g' /etc/mysql/mysql1.conf.d/mysqld.cnf
    sudo sed -i 's/#server-id               = 1/server-id              = 2/g' /etc/mysql/mysql2.conf.d/mysqld.cnf

    # slave na porcie 3307
    sudo sed -i 's/3306/3307/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo sed -i 's/mysqld.pid/mysqld_slave.pid/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo sed -i 's/mysqld.sock/mysqld_slave.sock/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo sed -i 's/var\/lib\/mysql/var\/lib\/mysql_slave/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo sed -i 's/var\/lib\/mysql/var\/lib\/mysql_slave/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo sed -i 's/var\/log\/mysql\/error.log/var\/log\/mysql_slave\/error_slave.log/g' /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo 'relay-log           = /var/log/mysql_slave/relay-bin' > /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo 'relay-log-index     = /var/log/mysql_slave/relay-bin.index' > /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo 'master-info-file    = /var/log/mysql_slave/master.info' > /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo 'relay-log-info-file = /var/log/mysql_slave/relay-log.info' > /etc/mysql/mysql2.conf.d/mysqld.cnf
    sudo 'read_only           = 1' > /etc/mysql/mysql2.conf.d/mysqld.cnf

    sudo '[mysqld_multi]' > /etc/mysql/my.cnf
    sudo 'mysqld     = /usr/bin/mysqld_safe' > /etc/mysql/my.cnf
    sudo 'mysqladmin = /usr/bin/mysqladmin' > /etc/mysql/my.cnf
    sudo 'user       = multi_admin' > /etc/mysql/my.cnf
    sudo 'password   = multipass' > /etc/mysql/my.cnf


    sudo mkdir -p /var/lib/mysql_slave
    sudo chmod --reference /var/lib/mysql /var/lib/mysql_slave
    sudo chown --reference /var/lib/mysql /var/lib/mysql_slave

    sudo mkdir -p /var/log/mysql_slave
    sudo chmod --reference /log/lib/mysql /var/lib/mysql_slave
    sudo chown --reference /log/lib/mysql /var/lib/mysql_slave
    
    sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql_slave
    sudo mysqld_multi start
    sudo service mysql restart
    sudo mysqladmin --host=127.0.0.1 --port=3307 -u root password 'Qwerty!@#123'

    sudo mysql --host=127.0.0.1 --port=3306 -uroot -p'Qwerty!@#123' -e "GRANT SHUTDOWN ON *.* TO 'multi_admin'@'localhost' IDENTIFIED BY 'multipass'";
    sudo mysql --host=127.0.0.1 --port=3306 -uroot -p'Qwerty!@#123' -e "FLUSH PRIVILEGES;"

    sudo mysql --host=127.0.0.1 --port=3307 -uroot -p'Qwerty!@#123' -e "GRANT SHUTDOWN ON *.* TO 'multi_admin'@'localhost' IDENTIFIED BY 'multipass'";
    sudo mysql --host=127.0.0.1 --port=3307 -uroot -p'Qwerty!@#123' -e "FLUSH PRIVILEGES;"








# fi






