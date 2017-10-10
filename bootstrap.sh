#!/bin/bash -ex

if [[ ! $(grep -q dtoverlay=w1-gpio /boot/config.txt)]]
then 
	echo "dtoverlay=w1-gpio" >> /boot/config.txt
fi

apt-get update
apt-get upgrade

# Install necessary software
apt-get install -y git python3-w1thermsensor python3-pigpio
pip install awscli --upgrade
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

[[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh && chmod 700 $HOME/.ssh
[[ ! -e $HOME/.ssh/authorized_keys ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa.pub $HOME/.ssh/authorized_keys
[[ ! -e $HOME/.ssh/id_rsa ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa $HOME/.ssh/id_rsa

chmod 600 $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/id_rsa

# Set up git repo
cat <<EOF > $HOME/.ssh/known_hosts
github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF

mkdir -p /opt/gits
cd /opt/gits
git clone git@github.com:seledkinpylesos/rpi.git




