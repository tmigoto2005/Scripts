#!/bin/bash

cd /home/tmigoto/teste/
find . -type d > "/home/tmigoto/diretorios.txt" 

input="/home/tmigoto/diretorios.txt"
while IFS='' read -r line 
do
	echo $line
	chmod -R 775 $line
done < "$input"
