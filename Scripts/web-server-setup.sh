#!/usr/bin/expect -f
set SERVERUSER [lindex $argv 0]
set USERPASSWORD [lindex $argv 1]
set SERVERNAME [lindex $argv 2]
set APPREPO [lindex $argv 3]
set WEBSERVERPUBLICIP [lindex $argv 4]
set DBPASSWORD [lindex $argv 5]

set timeout 600
spawn ssh $SERVERUSER@$WEBSERVERPUBLICIP

expect "yes/no" { 
	send "yes\r"
	expect "assword:" { send "$USERPASSWORD\r" }
	} "assword:" { send "$USERPASSWORD\r" }

expect "$ " { send "sudo hostnamectl set-hostname $SERVERNAME && sudo sed -i '/localhost$/a 10.21.0.101 db' /etc/hosts && sudo apt update && sudo apt install apache2 php php-mysqlnd git expect\r" }

expect "Do you want to continue?" { send "y\r" }

expect "$ " { send "sudo ufw allow 'Apache' && sudo ufw reset\r" } 

expect "Proceed with operation (y|n)?" { send "y\r" }

expect "$ " { send "git clone $APPREPO && sudo cp -v bgapp/web/* /var/www/html && sudo rm /var/www/html/index.html\r" } 

expect "$ " { send "git clone https://github.com/dab1ca/AzureApp.git && sudo expect /home/$SERVERUSER/AzureApp/Scripts/db-server-setup.sh $SERVERUSER $USERPASSWORD $DBPASSWORD db $APPREPO 10.21.0.101\r" }

expect "$ " { send "sudo rm -r /home/$SERVERUSER/AzureApp\r"}

expect "$ " { send "exit\r" }
expect eof
