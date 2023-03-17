#!/usr/bin/expect -f
set SERVERUSER [lindex $argv 0]
set USERPASSWORD [lindex $argv 1]
set SERVERNAME [lindex $argv 2]
set APPREPO [lindex $argv 3]
set WEBSERVERPUBLICIP [lindex $argv 4]
spawn ssh $SERVERUSER@$WEBSERVERPUBLICIP
expect "assword:"
send "$USERPASSWORD\r"
send "sudo hostnamectl set-hostname $SERVERNAME\r"
send "sudo apt update\r"
send "sudo apt install apache2 php php-mysqlnd git\r"
expect "Do you want to continue?"
send "Y\r"
sleep 45
send "sudo ufw allow 'Apache' && sudo ufw reset\r"
expect "Proceed with operation"
send "Y\r"
send "sudo git clone $APPREPO\r"
send "sudo cp -v bgapp/web/* /var/www/html\r"
send "sudo rm /var/www/html/index.html\r"
send "echo Finished"