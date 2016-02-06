#!/bin/bash
#
#
#

#wget mysql-5.6.14 not install pack:
yum install -y gzip
cd /usr/local/src/
if [ -f mysql-5.6.14-linux-glibc2.5-x86_64.tar.gz ];then
   echo "mysql-5.6.14 pack is exist!"
else
   echo "mysql pack is not exist,............now  download..................."
   wget http://cdn.mysql.com/archives/mysql-5.6/mysql-5.6.14-linux-glibc2.5-x86_64.tar.gz
fi

tar -zxf mysql-5.6.14-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.6.14-linux-glibc2.5-x86_64 /usr/local/mysql
groupadd mysql
useradd -g mysql -M mysql 
mkdir -p /data
chown -R mysql.mysql /data


[ -f /etc/my.cnf ] &&  mv /etc/my.cnf /etc/my.cnf_old 

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
ln -s /usr/local/mysql/my.cnf /etc/my.cnf

cat>/etc/my.cnf<<EOF
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.6/en/server-configuration-defaults.html
[mysqld]
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
innodb_buffer_pool_size = 128M
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
# These are commonly set, remove the # and set as required.
basedir = /usr/local/mysql
datadir = /data
port = 3306
# server_id = .....
socket = /tmp/mysql.sock
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
join_buffer_size = 128M
sort_buffer_size = 2M
read_rnd_buffer_size = 2M
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
EOF



/etc/init.d/mysqld start
echo " "

ps -ef | grep -v "grep mysql" |grep mysql
if [ $? -eq 0 ];then
   echo "mysql is install successful"
   exit 0
else
   echo "mysql is install failure!"
   exit 1
fi





