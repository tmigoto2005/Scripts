#!/bin/bash
input_file="/Users/tmigoto/rm_list.txt"
while IFS='' read -r  line 
do
	rm $line
done < "$input_file"
