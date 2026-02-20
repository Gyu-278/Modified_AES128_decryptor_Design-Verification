#!/bin/sh

#hextoasci
#after decryption

i=1
j=0
k=0
cnt=0
while read line || [ -n "$line" ] ; do
    
    ((i+=1))
    j=0
    ((cnt+=1))
	if [ $(($cnt%2)) -eq 1 ]
	then 
	printf "\n" 
	fi
    while [ $j -lt 32 ]
    do
    
		if [ $((16#${line:$j:2})) -eq 00 ]
		then
		
		printf " "
		fi
		
		
		printf "\x${line:$j:2}"
		sleep 0.01
        ((j+=2))
		
		
	
	done
	
	
done < decrypted.txt