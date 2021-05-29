#!/bin/bash

while true
do

user=($(users | sort | head -n 20))
cmd=($(ps -o cmd | tr -d " "))
pid=($(ps -o pid | tr -d " "))
stime=($(ps -o stime | tr -d " "))

echo "______                     _    _                   "
echo "| ___ \                   | |  (_)                  "   
echo "| |_/ / _ __   __ _   ___ | |_  _   ___   ___       "
echo "|  __/ |  __| / _  | / __|| __|| | / __| / _ \      "
echo "| |    | |   | (_| || (__ | |_ | || (__ |  __/      "
echo "\_|    |_|    \__,_| \___| \__||_| \___| \___|      "
echo " _                _                                 "
echo "(_)       | |    (_)                                "
echo " _  _ __  | |     _  _ __   _   _ __  __            " 
echo "| ||  _ \ | |    | ||  _ \ | | | |\ \/ /            "
echo "| || | | || |____| || | | || |_| | >  <             "
echo "|_||_| |_|\_____/|_||_| |_| \__,_|/_/\_\            "
echo "                                                    "
echo "-NAME----------------CMD-----------------PID---STIME----"

for((i=0; i<24; i++))
do    		
       	echo -n "|"    		
	for((k=18; k >= ${#user[$i]}; k--))
	do
	        echo -n " "
        done
        echo -n ${user[$i]}

	echo -n "|"
	echo -n ${cmd[$i+1]}              
	for(( k=18; k >= ${#cmd[$i+1]}; k--))
	do
		echo -n " "
	done

	echo -n "|"    
	for(( k=4; k >= ${#pid[$i+1]}; k--))
	do
		echo -n " "
	done
	echo -n ${pid[$i+1]}    

	echo -n "|" 
	for(( k=7; k >= ${#stime[$i+1]}; k--))
	do
		echo -n " "
	done
	echo -n ${stime[$i+1]}     
	echo "|"
done	

echo "--------------------------------------------------------"

echo "If you want to exit, Please Type 'q' or 'Q'"

read -t 3 -n 1 ans

if [ "${ans}" = "q" ]; then
	clear; exit

elif [ "${ans}" = "Q" ]; then
	clear; exit

else
	clear; continue; 

fi

done 

