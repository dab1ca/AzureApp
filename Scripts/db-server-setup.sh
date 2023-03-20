#!/usr/bin/expect -f
set SERVERUSER [lindex $argv 0]
set USERPASSWORD [lindex $argv 1]
set DBROOTPASSWORD [lindex $argv 2]
set SERVERNAME [lindex $argv 3]
set APPREPO [lindex $argv 4]
set DBIPADDRESS [lindex $argv 5]

spawn ssh $SERVERUSER@$DBIPADDRESS

set timeout 60

expect "yes/no" { 
	send "yes\r"
	expect "assword:" { send "$USERPASSWORD\r" }
	} "assword:" { send "$USERPASSWORD\r" }

expect "$ " { send "sudo hostnamectl set-hostname $SERVERNAME && sudo apt install mariadb-server git\r" }
expect "Do you want to continue?" { send "Y\r" }

expect "$ " { send "sudo mysql_secure_installation\r" }
expect "Enter current password for root" { send "\r" }
expect "Change the root password?" { send "Y\r" } 
expect "New password:" { send "$DBROOTPASSWORD\r" } 
expect "Re-enter new password:" { send "$DBROOTPASSWORD\r" }
expect "Remove anonymous users?" { send "n\r" }
expect "Disallow root login remotely" { send "n\r" } 
expect "Remove test database and access to it?" { send "Y\r" }
expect "Reload privilege tables now?" { send "Y\r" }

expect "$ " { send "git clone $APPREPO && sudo mysql -u root -p < ~/bgapp/db/db_setup.sql\r" }
expect "Enter password:" { send "$DBROOTPASSWORD\r" }

expect "$ " { send "sudo ufw disable\r" }

expect "$ " { send "sudo sed -i 's|127.0.0.1|$DBIPADDRESS|' /etc/mysql/mariadb.conf.d/50-server.cnf\r" }

expect "$ " { send "sudo service mysql restart\r" } 

expect "$ " { send "exit\r" }
expect eof