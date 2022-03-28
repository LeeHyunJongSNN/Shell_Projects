#!/bin/bash

cursor=0
sub_cursor=-1
flag=0
add=0
input="   "

function logo() {
	echo ""
	echo '______                     _    _             '
	echo '| ___ \                   | |  (_)             '
	echo '| |_/ / _ __   __ _   ___ | |_  _   ___   ___  '
	echo '|  __/ |  __| / _  | / __|| __|| | / __| / _ \ '
	echo '| |    | |   | (_| || (__ | |_ | || (__ |  __/ '
	echo '\_|    |_|    \__,_| \___| \__||_| \___| \___| '
	echo ""
	echo '(_)       | |    (_)                    '
	echo ' _  _ __  | |     _  _ __   _   _ __  __'
	echo '| ||  _ \ | |    | ||  _ \ | | | |\ \/ /'
	echo '| || | | || |____| || | | || |_| | >  < '
	echo '|_||_| |_|\_____/|_||_| |_| \__,_|/_/\_\'
	echo ""
}

function getUsers() {
	#using ps, get Uers, return to arrUsers
	arrUsers=(`ps -ef | cut -f 1 -d " " | sed "1d" | sort | uniq`)
}

function getCmds() {
	#IFS : Internal Field Separator 내부 필드 구분자

	#using ps, get CMDs, return to arrCmds
	ps -ef | sort -r > temp
	grep ^$1 temp > psfu
	rm ./temp
	ps ax -ef | sort -r > stat
	grep ^$1 stat > psstat
	rm ./stat

	IFS_backup="$IFS"
	# backup IFS
	IFS=$'\n'
	arrCmds=(`cat psfu | cut -c 52-`)
	arrPIDs=(`cat psfu | cut -c 11-16`)
	arrSTIMEs=(`cat psfu | awk '{print $5}'`)
	#arrSTIMEs=(`cat psfu | cut -c 25-29`)

	arrGROUNDs=(`cat psstat | cut -c 44-47 | sed -e s/R+/F/g | sed -e s/S+/F/g | sed -e s/Rl+/F/g | sed -e s/Sl+/F/g | sed -e s/Ssl+/F/g | sed -e s/Ss/B/g | sed -e s/S/B/g | sed -e s/I/B/g | sed -e s/SNsl/B/g | sed -e s/Ssl/B/g | sed -e s/Sl/B/g | sed -e s/SLl/B/g | sed -e s/S'<'sl/B/g | sed -e s/S'<'/B/g | sed -e s/I'<'/B/g | sed -e s/SN/B/g | cut -c 1-1`)
        arrSTATs=(`cat psstat | cut -c 44-47`)

	loginUSER=(`users`)

	IFS="$IFS_backup"
	# restore IFS
}

getUsers
getCmds ${arrUsers[$cursor]}

numUsers=${#arrUsers[*]}
numCmds=${#arrCmds[*]}

highlight() {
	if [ $2 = $1 ]; then
		echo -n [$3m
	fi
}

until [ "$input" = "q" -o "$input" = "Q" ]; do
clear
	getUsers
	getCmds ${arrUsers[$cursor]}

	numUsers=${#arrUsers[*]}
	numCmds=${#arrCmds[*]}

	# 1 + 20 + 1 + 20 + 1 + 5 + 1 + 8 + 1
	logo
        echo "-NAME-----------------CMD--------------------PID------STIME----"
        for (( i=0; i<20; i++)); do
        printf "|"
        highlight $i $cursor 41
        	printf "%20s" ${arrUsers[$i]}
        	echo -n [0m
        printf "|"
        	IFS_backup="$IFS"
        	IFS=$'\n'
        highlight $i $sub_cursor 42
        	printf "%1s" ${arrGROUNDs[$i+$add]}
        	printf "%-21.21s|%8s|%8s" ${arrCmds[$i+$add]} ${arrPIDs[$i+$add]} ${arrSTIMEs[$i+$add]}
        echo -n [0m
        printf "|"
        	IFS="$IFS_backup"
        	printf "\n"
        done
        echo "---------------------------------------------------------------"
        echo "If you want to exit , Please Type 'q' or 'Q'"
	echo "If you want to kill process , Please Type 'k' or'K'"
	printf ""
	
	read -n 3 -t 3 input
	case "$input" 
	in
		[A) [ $flag -eq 0 ] && [ $cursor -gt 0 ] && cursor=`expr $cursor - 1` || [ $sub_cursor -gt 0 ] && sub_cursor=`expr $sub_cursor - 1`
		      if [ $sub_cursor -gt 19 ]; then
                              for (( k=1; k<$sub_cursor; k++)); do
                                   add=$k-18
                              done
		      elif [ $sub_cursor -le 20 ]; then
			      add=0
		      fi;;
		      
		[B) if [ $flag -eq 0 ]; then 
			 [ $cursor -lt `expr $numUsers - 1` ] && cursor=`expr $cursor + 1`
		         elif [ $flag -eq 1 ]; then 
		         [ $sub_cursor -lt `expr $numCmds - 1` ] && sub_cursor=`expr $sub_cursor + 1` 
		      if [ $sub_cursor -gt 19 ]; then
			      for (( k=1; k<$sub_cursor; k++)); do
				   add=$k-18
			      done
		      fi
		      fi;;

        	[C) [ $flag -eq 0 ] && sub_cursor=0 && flag=1 && add=0 ;;

        	[D) [ $flag -eq 1 ] && flag=0 && sub_cursor=-1 && add=0 ;; 
	esac

	if [ "${input}" = "k" ] && [ "${arrUsers[$cursor]}" == "${loginUSER}" ]; then
		echo ""
		echo "Are you sure? Press Enter to kill process (If you don't want to kill process, Please Press any key without direction keys)"
		echo "User: ${arrUsers[$cursor]}     Cmd:${arrCmds[$sub_cursor]}      PID:${arrPIDs[$sub_cursor]}     Status: ${arrSTATs[$sub_cursor]}"
		read -n 1 ans
		
		if [ "$ans" = "" ]; then
			kill -9 ${arrPIDs[$sub_cursor]} 
		else
			clear;
		fi

	elif [ "${input}" = "k" ] && [ "${arrUsers[$cursor]}" != "${loginUSER}" ]; then
		echo ""
		echo "User: ${arrUsers[$cursor]}     Cmd:${arrCmds[$sub_cursor]}      PID:${arrPIDs[$sub_cursor]}     Status: ${arrSTATs[$sub_cursor]}"
		echo "No Permission!!"
		exit;
	fi
done
