#!/bin/bash
randomQues()
{
    #random a ordinal position number of question is empty
    if [ $notAnswerCount -ne 0 ]
    then
        temp=$(($RANDOM%$notAnswerCount))
    else
        temp=0
    fi

    #run and get value
    nonChecked=0
    for ((k=0;k<$fileCount;k++))
    do
        if [ ${Ques[$k]} -eq 0 ] 
        then 
            if [ $nonChecked -eq $temp ]
            then
                Ques[$k]=1
                notAnswerCount=$[$notAnswerCount-1]
                R=$k
                break;
            else
                nonChecked=$[$nonChecked+1]
            fi
        fi
    done
}
clear
while [ "$y" != "y" ]
do
    clear
    echo "Xin chao $USER, ban da san sang lam trieu phu chua?"
    echo -n "Nhan y de bat dau > "
    read y
done

#Start the game
echo "$USER da san sang tro thanh TRIEU PHU"
echo ""
fail="false"
changeAnsChecked="false"
eraseChecked="true"
ansCount=0

#Count file in ./Question then random number
fileCount=0
for item in $LOCATION./Question/*
do
    [ -f $item ] && fileCount=$[$fileCount+1]
done

notAnswerCount=$fileCount

#Define array
for ((i=0;i<$fileCount;i++))
do
    Ques[$i]=0
done

#Game Start
while [ "$fail" = "false" ]
do
    [ $notAnswerCount -ne 0 ] && {
        #Random a number of Question
        randomQues

        #Direct to file question and answer
        fileQues="./Question/Question""$R"".txt"
        fileAns="./Answer/Answer""$R"".txt"

        cat $fileQues

        #Alert and wait for user answer question
        [ $eraseChecked = "true" ] && echo "Tra loi \"e\" neu ban muon su dung tro giup 50:50"
        [ $changeAnsChecked = "false" ] && echo "Tra loi \"ca\" neu ban muon su dung tro giup doi cau hoi"
        echo -n "Dap an cua ban la > "

        #Read file Answer
        ans=""
        while read line
        do
            ans=$line
        done < "$fileAns"

        answered="false"
        while [ "$answered" = "false" ]
        do
            read userAns

            case $userAns in
                a|b|c|d)
                    if [ "$userAns" = "$ans" ]
                    then
                        ansCount=$[$ansCount+1]
                        echo Dung roi. Ban da tra loi dung $ansCount cau hoi
                        answered="true"
                    else
                        echo Ban da tra loi sai
                        fail="true"
                        answered="true"
                    fi
                    echo ;;
                e)
                    #If they did not use erase
                    if [ "$eraseChecked" = "true" ]
                    then
                        eraseChecked="false"
                        ./subscript/erase.sh $fileQues $ans
                    #if they did
                    else
                        echo Ban da su dung quyen tro giup 50:50
                    fi
                    [ $changeAnsChecked = "false" ] && echo "Tra loi \"ca\" neu ban muon su dung tro giup doi cau hoi"
                    echo -n "Dap an cua ban la > "
                    echo -n ;;
                ca)
                    #If user did not use change
                    if [ "$changeAnsChecked" = "false" ]
                    then
                        answered="true"
                        changeAnsChecked="true"
                        echo ""
                    #if they did
                    else
                        echo "Ban khong the chuyen cau hoi"
                        echo -n "Dap an cua ban la > "
                    fi
                    echo -n ;;
                *)
                    echo Ban da tra loi sai
                    fail="true"
                    answered="true"
            esac
        done

        [ $notAnswerCount -eq 0 ] && fail="true"
    }
done
[ $notAnswerCount -ne 0 ] && echo $USER thua cuoc voi $ansCount trieu dong. Chuc mung $USER
[ $notAnswerCount -eq 0 ] && echo $USER thang cuoc voi $ansCount trieu dong. Chuc mung $USER

#exit
exit 0
