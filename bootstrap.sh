#!/bin/bash -x

if [[ ! $(grep -q dtoverlay=w1-gpio /boot/config.txt) ]]
then 
	echo "dtoverlay=w1-gpio" >> /boot/config.txt
fi

apt-get -y update
apt-get -y upgrade

# Install necessary software
apt-get install -y git python3-w1thermsensor python3-pigpio
pip install awscli --upgrade
pip install boto3

# Set AWS creds and config
if [[ ! -e $HOME/.aws/credentials ]]
then
	mkdir $HOME/.aws
	cat <<EOF > $HOME/.aws/credentials
[default]
AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
AWS_DEFAULT_REGION=us-east-2
EOF
fi

if [[ ! -e $HOME/.aws/config ]]
then
	cat <<EOF > $HOME/.aws/config
[default]
region = us-east-2
EOF
fi

# Set aliases for pi
if [[ ! $(grep -q "alias ll='ls -alFG'" /home/pi/.bashrc) ]]
then
	cat <<EOF >> /home/pi/.bashrc
alias ll='ls -alFG'
alias python=python3
EOF
fi

# Copy .bashrc file to the root user for fancy prompt and aliases
cp /home/pi/.bashrc $HOME/.bashrc

# Install ssh keys
[[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh && chmod 700 $HOME/.ssh
[[ ! -e $HOME/.ssh/authorized_keys ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa.pub $HOME/.ssh/authorized_keys
[[ ! -e $HOME/.ssh/id_rsa ]] && aws s3 cp s3://us-east-2-rpi-creds/id_rsa $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/id_rsa

# Set up git repo
if [[ ! -e $HOME/.ssh/known_hosts ]] || [[ ! $(grep -q github.com $HOME/.ssh/known_hosts) ]]
then 
	cat <<EOF > $HOME/.ssh/known_hosts
github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF
fi

if [[ ! -d /opt/gits ]]
then
	mkdir -p /opt/gits
	cd /opt/gits
	git clone git@github.com:seledkinpylesos/rpi.git
fi

# Create boot script for modprobe
if [[ ! -e /etc/init.d/boot_script.sh ]]
then
	cat <<EOF > /etc/init.d/boot_script.sh
#!/bin/bash -ex

modprobe w1-gpio
modprobe w1-therm
>&2 echo "Executed modprobe"
EOF
	chmod +x /etc/init.d/boot_script.sh
	update-rc.d /etc/init.d/boot_script.sh defaults
fi
