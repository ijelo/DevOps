#!/usr/bin/env bash

if [ -f /etc/fstab.new ] 
then
   mv /etc/fstab /etc/fstab.org
   mv /etc/fstab.new /etc/fstab
fi

### Reset network names to ethx

### cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << _EOF_
### # Generated by ks.cfg
### NAME="eth0"
### DEVICE="eth0"
### ONBOOT=yes
### NETBOOT=yes
### IPV6INIT=yes
### BOOTPROTO=dhcp
### TYPE=Ethernet
### _EOF_

### mv /etc/sysconfig/network-scripts/ifcfg-enp0s3 /root/.

### sed -i 's/rhgb quiet/rhgb quiet net.ifnames=0 biosdevname=0/g' /etc/default/grub

### grub2-mkconfig -o /boot/grub2/grub.cfg

### mv /etc/fstab /etc/fstab.org
### mv /etc/fstab.new /etc/fstab

#### Tighten UMASK
cp /etc/bashrc /etc/bashrc.org 
cp /etc/csh.cshrc /etc/csh.cshrc.org 
cp /etc/profile /etc/profile.org
perl -npe 's/umask\s+0\d2/umask 077/g' -i /etc/bashrc 
perl -npe 's/umask\s+0\d2/umask 077/g' -i /etc/csh.cshrc 
perl -npe 's/umask\s+0\d2/umask 077/g' -i /etc/profile

cat >> ~/.bash_profile << _EOF_
export PS1="\[\033[38;5;163m\]\u\[$(tput sgr0)\]\[\033[38;5;0m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;0m\]:\[$(tput sgr0)\]\[\033[38;5;4m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;0m\][\[$(tput sgr0)\]\[\033[38;5;1m\]\$?\[$(tput sgr0)\]\[\033[38;5;0m\]] \\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
_EOF_

cat > /etc/resolv.conf << _EOF_
#
# This file is automatically generated.
#
domain google.com
nameserver 8.8.8.8
nameserver 8.8.4.4
_EOF_


rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB

#
# https://downloads.mariadb.org/mariadb/repositories/#mirror=babylon-nl&distro=CentOS&distro_release=centos7-amd64--centos7&version=10.2
#
cat > /etc/yum.repos.d/MariaDB.repo << _EOF_
# MariaDB 10.2 CentOS repository list - created 2018-02-27 09:23 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
_EOF_


yum -y update
yum install -y MariaDB-server MariaDB-client


systemctl start mariadb
systemctl enable mariadb

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "${SECURE_MYSQL}"

pushd /root


curl 'https://setup.ius.io/' -o setup-ius.sh
bash setup-ius.sh

yum -y install mod_php70u php70u-cli php70u-mysqlnd php70u-devel php70u-gd php70u-mcrypt php70u-mbstring php70u-xml php70u-pear
systemctl restart httpd

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-service={http,https} --permanent
firewall-cmd --reload


popd


pear install DB

### semanage fcontext -a -t httpd_sys_content_t "/var/www/html/daloradius(/.*)?"
### restorecon -Rv /var/www/html/daloradius

echo "Finished bootstrap installation script."
echo "rebooting..."
init 6

