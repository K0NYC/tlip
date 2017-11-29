#!/bin/bash

counter=0

while [ $counter -lt 3 ];
do
  ping 192.168.10.1 -c 4 -i 3 -q
	if [[  $(echo $?) -ne 0 ]]
	then
			((counter+=1))
			sleep 60
	else
			exit 0
	fi
done

if [ $counter -eq 3 ]
then
        logger Ping failed. Rebooting...
        /sbin/shutdown -r now
fi
