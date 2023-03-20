#!/usr/bin/expect -f
set SERVERUSER [lindex $argv 0]
set USERPASSWORD [lindex $argv 1]
set SERVERNAME [lindex $argv 2]
set APPREPO [lindex $argv 3]
set WEBSERVERPUBLICIP [lindex $argv 4]

set timeout 25
spawn ssh $SERVERUSER@$WEBSERVERPUBLICIP

expect "yes/no" { 
	send "yes\r"
	expect "assword:" { send "$USERPASSWORD\r" }
	} "assword:" { send "$USERPASSWORD\r" }

expect "$ " { send "sudo hostnamectl set-hostname $SERVERNAME && sudo apt update && sudo apt install apache2 php php-mysqlnd git\r" }

expect "Do you want to continue?" { send "y\r" }

expect "$ " { send "sudo ufw allow 'Apache' && sudo ufw reset\r" } 

expect "Proceed with operation (y|n)?" { send "y\r" }

expect "$ " { send "sudo git clone $APPREPO && sudo cp -v bgapp/web/* /var/www/html && sudo rm /var/www/html/index.html\r" } 

expect "$ " { send "exit\r" }
expect eof
