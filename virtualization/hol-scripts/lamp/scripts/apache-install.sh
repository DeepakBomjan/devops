#! /bin/bash

apt-get update -y

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y apache2;
fi

if [ $(dpkg-query -W -f='${Status}' php5 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y php5;
fi
