read -e -p "Enter the path to the file: " path
eval path=$path
for FILE in $path/*.txt
do 
    mv "$FILE" $(echo "$FILE" | sed 's/.txt/.cfg/')
done
