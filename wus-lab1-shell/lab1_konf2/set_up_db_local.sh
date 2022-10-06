#!/bin/bash

if [ -f /etc/init.d/mysql* ]; then
    echo "mysql installed"
else 
    # instalacja mysql 
    sudo apt-get update
    sudo apt-get install mysql-client -y 
    sudo apt-get install mysql-server -y 

    # zmiana pliky konfiguracyjnego mysql - możliwe łączenie z zewnątrz hosta
    sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo service mysql restart

    # inicjacja hasła roota 
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Qwerty!@#123';"

    # utworzenie konata na potzeby aplikacji + utworzenie bazy petclinic - resztę generacji bazy zrobi jpa
    mysql -uroot -p'Qwerty!@#123' -e "CREATE USER 'petclinic' IDENTIFIED BY 'petclinic';"
    mysql -uroot -p'Qwerty!@#123' -e "GRANT ALL PRIVILEGES ON *.* TO 'petclinic' WITH GRANT OPTION;"
    mysql -u'petclinic' -p'petclinic' -e "CREATE DATABASE petclinic;"
fi






