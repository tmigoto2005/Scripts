read -e -p "Word to be counted: " word
eval word=$word
#echo $word
read -e -p "Enter the path to the file: " path
eval path=$path
#echo $path
tr -s ' ' '\n' < $path | grep $word | wc -l

