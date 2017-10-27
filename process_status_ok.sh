#!/bin/bash

numberOfProcesses=$(ps -ef | grep unicorn_rails | grep -v grep | wc -l)
currentDate=$(date)

echo "***** $currentDate - $numberOfProcesses running. *****" >> /tmp/check_unicorn.out

if [ "$numberOfProcesses" -lt 9 ]; then
   echo "$currentDate - Not ok. I would do the following things, if I were you." >> /tmp/check_unicorn.out
   echo "killall -s 9 -u deploy" >> /tmp/check_unicorn.out
   echo "sudo -u deploy -E -- bundle exec rake environment resque:scheduler" >> /tmp/check_unicorn.out
   echo "/srv/www/checkout/shared/scripts/unicorn restart" >> /tmp/check_unicorn.out
else
   echo "$currentDate - Everything ok by now." >> /tmp/check_unicorn.out
fi
