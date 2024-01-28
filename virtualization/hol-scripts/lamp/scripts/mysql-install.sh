#! /bin/bash

apt-get update -y

echo "mysql-server mysql-server/root_password password pinehead" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password pinehead" | debconf-set-selections

if [ $(dpkg-query -W -f='${Status}' mysql-server-5.5 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y mysql-server-5.5;
fi
