#!/bin/bash
do
if [ -d /home/tmigoto/teste/$dir ]
then
rm -R $dir
echo “Directory $dir found and deleted.”
else
echo “Directory $dir not found.”
fi
done < dir_list
