#!/bin/bash
#convert abcd to 0123
case $2 in
    a) ans=0;;
    b) ans=1;;
    c) ans=2;;
    d) ans=3;;
esac

echo -n ""
echo ""

#random until R != ans
R=$(($RANDOM%4))
while [ "$R" -eq "$ans" ]
do
    R=$(($RANDOM%4))
done


link=-1
while IFS= read -r var
do
    if [ "$link" -eq "$R" ] || [ "$link" -eq "$ans" ] || [ "$link" -eq -1 ]
    then
        echo $var
    fi
    link=$[$link + 1]
done < "$1"

exit 0