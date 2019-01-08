#!/bin/bash 
 
ME="$(whoami)"
################# Installation of MySQL 5.5.59  ###############################
mkdir /home/"$ME"/source
cd /home/"$ME"/source
mkdir ./mysql 
cd ./mysql
sleep 2

wget -nc https://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.59.tar.gz
tar -zxvf mysql-5.5.59.tar.gz
rm -rf 5.5.59/
mv mysql-5.5.59 5.5.59
cd ./5.5.59
mkdir ./build 
cd ./build

mkdir /home/"$ME"/software
mkdir /home/"$ME"/software/mysql
mkdir /home/"$ME"/software/mysql/5.5.59
mkdir /home/"$ME"/software/mysql/5.5.59/data

sleep 2
cmake ..  -DCMAKE_INSTALL_PREFIX=/home/"$ME"/software/mysql/5.5.59 -DMYSQL_DATADIR=/home/"$ME"/software/mysql/5.5.59/data -DWITH_DEBUG=1
make -j 16
sudo make install

# Initialize the data directory
# https://dev.mysql.com/doc/refman/5.5/en/data-directory-initialization.html
cd /home/"$ME"/software/mysql/5.5.59/

scripts/mysql_install_db  --basedir=/home/"$ME"/software/mysql/5.5.59 --datadir=/home/"$ME"/software/mysql/5.5.59/data
cp ./support-files/my-huge.cnf .
mv my-huge.cnf my.cnf
vim my.cnf

/home/"$ME"/software/mysql/5.5.59/bin/mysqld_safe --defaults-file=/home/"$ME"/software/mysql/5.5.59/my.cnf &

sleep 3

/home/"$ME"/software/mysql/5.5.59/bin/mysqladmin -S /home/"$ME"/software/mysql/5.5.59/mysql.sock -u root password 'password'


#create the testing database

/home/"$ME"/software/mysql/5.5.59/bin/mysql -S /home/"$ME"/software/mysql/5.5.59/mysql.sock -u root -ppassword -e "create database sysbench"
