#! /bin/bash

case "$(ps aux | grep -v grep |grep unicorn | grep master | wc -l)" in

0)  sudo echo "Starting Unicorn:     $(date)" >> /var/log/unicorn_monitoring.txt
    sudo /srv/www/checkout/shared/scripts/unicorn restart
    ;;
1)  echo "Unicorn OK"
    ;;
*)  sudo echo "Removed double Unicorn: $(date)" >> /var/log/unicorn_monitoring.txt
    sudo /srv/www/checkout/shared/scripts/unicorn restart
    ;;
esac

