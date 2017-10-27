#! /bin/bash

case "$(ps aux | grep -v grep |grep checkout | grep master | wc -l)" in

0)  sudo echo "Starting Checkout:     $(date)" >> /var/log/checkout_monitoring.txt
#    sudo /srv/www/checkout/shared/scripts/unicorn restart     
    ;;
1)  echo "Checkout OK"
    ;;
*)  sudo echo "Removed double Checkout: $(date)" >> /var/log/checkout_monitoring.txt
#    sudo /srv/www/checkout/shared/scripts/unicorn restart
    ;;
esac

