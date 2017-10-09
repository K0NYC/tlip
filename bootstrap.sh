#!/bin/bash -ex

if [[ ! $(grep -q dtoverlay=w1-gpio /boot/config.txt)]]
then 
	echo "dtoverlay=w1-gpio" >> /boot/config.txt
fi

apt-get update
apt-get upgrade

# Install necessary software
apt-get install -y git awscli python3-w1thermsensor python3-pigpio

pip install boto3

# Set aliases and AWS creds 
cat <<EOF > /home/pi/.bashrc

export AWS_ACCESS_KEY_ID='$1'
export AWS_SECRET_ACCESS_KEY='$2'
export AWS_DEFAULT_REGION='us-east-2'
alias ll='ls -alFG'

EOF

# Copy .bashrc file to the root user
cp /home/pi/.bashrc $HOME/.bashrc


# Install ssh keys
export $HOME/.bashrc

[[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh && chmod 600 $HOME/.ssh
[[ ! -e $HOME/.ssh/authorized_keys ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa.pub $HOME/.ssh/authorized_keys
[[ ! -e $HOME/.ssh/id_rsa ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa $HOME/.ssh/id_rsa

chmod 600 $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/id_rsa


aws s3 cp 



