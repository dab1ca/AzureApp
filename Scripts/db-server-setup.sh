#!/usr/bin/expect -f
set SERVERUSER [lindex $argv 0]
set USERPASSWORD [lindex $argv 1]
set DBROOTPASSWORD [lindex $argv 2]
set SERVERNAME [lindex $argv 3]
set APPREPO [lindex $argv 4]
set DBIPADDRESS [lindex $argv 5]
spawn ssh $SERVERUSER@$DBIPADDRESS
expect "assword:"
send "$USERPASSWORD\r"
send "sudo hostnamectl set-hostname $SERVERNAME\r"
send "sudo apt install mariadb-server git\r"
expect "Do you want to continue?"
send "Y\r"
set timeout 45
send "sudo mysql_secure_installation\r"
expect "Enter current password for root"
send "\r"
expect "Change the root password?"
send "Y\r"
expect "New password:"
send "$DBROOTPASSWORD\r"
expect "Re-enter new password:"
send "$DBROOTPASSWORD\r"
expect "Remove anonymous users?"
send "n\r"
expect "Disallow root login remotely"
send "n\r"
expect "Remove test database and access to it?"
send "Y\r"
expect "Reload privilege tables now?"
send "Y\r"
send "git clone $APPREPO\r"
send "sudo mysql -u root -p < ~/bgapp/db/db_setup.sql\r"
expect "Enter password:"
send "$DBROOTPASSWORD\r"
send "sudo ufw disable\r"
send "sudo sed -i 's|127.0.0.1|$DBIPADDRESS|' /etc/mysql/mariadb.conf.d/50-server.cnf\r"
send "sudo service mysql restart\r"