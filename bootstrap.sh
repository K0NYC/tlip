#!/bin/bash -ex

if [[ ! $(grep -q dtoverlay=w1-gpio /boot/config.txt)]]
then 
	echo "dtoverlay=w1-gpio" >> /boot/config.txt
fi

apt-get update
apt-get upgrade

apt-get install -y git awscli  	























