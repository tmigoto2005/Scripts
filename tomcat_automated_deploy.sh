#!/bin/bash
DATE=$(date '+%d%m%Y')
DIRECTORY=(/deploy/)
LOG=(/home/ubuntu/deploy_$DATE.log)

# Copia arquivos do S3
aws s3 mv s3://bucket/ $DIRECTORY --recursive --include "*.war" >> $LOG

if [ $(ls -1 $DIRECTORY | wc -l) -gt 0 ]; then

echo "Starting deploy $(date '+%H:%M:%S')" >> $LOG
TomcatPID=$(ps -ef |grep tomcat7 | grep -v grep | awk '{print ($2)}')
kill -9 $TomcatPID
echo "Tomcat stopped $(date '+%H:%M:%S')" >> $LOG

for file in $(ls -1 $DIRECTORY)
do
  rm -rf /opt/tomcat7/webapps/$file
  folder=$(ls -1 $DIRECTORY |awk -F"." '{print ($1)}')
  rm -rf /opt/tomcat7/webapps/$folder
  cp /deploy/$file /opt/tomcat7/webapps/
  chown tomcat:tomcat /opt/tomcat7/webapps/$file
done

mv $DIRECTORY* /deploy_old/
su tomcat -c "/opt/tomcat7/bin/startup.sh" & >> $LOG
echo "Deploy finished $(date '+%H:%M:%S')" >> $LOG
else
echo "No new files to be deployed $(date '+%H:%M:%S')" >> $LOG
fi
