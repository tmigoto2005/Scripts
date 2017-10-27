#!/bin/bash

cd /home/tmigoto/teste/
find . -type f > "/home/tmigoto/arquivos.txt" 

input="/home/tmigoto/arquivos.txt"
while IFS='' read -r line 
do
	echo $line
	chmod 644 $line
done < "$input"
