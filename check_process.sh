#! /bin/bash

case "$(ps aux | grep -v grep |grep mysql | wc -l)" in

0)  sudo echo "Restarting MySQL:     $(date)" >> /var/log/mysql_teste.txt
    sudo /etc/init.d/mysql start 
    ;;
1)  echo "MySQL OK"
    ;;
*)  sudo echo "Removed double MySQL: $(date)" >> /var/log/mysql_teste.txt
    sudo /etc/init.d/mysql restart
    ;;
esac
