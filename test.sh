#!/bin/bash

while true; do
        arr=($(ps -o cmd | tr -d " "))
	for num in "${arr[@]}";
	do echo $num;
	done;
	sleep 3; clear; done

