#!/usr/bin/env bash
gitBranch=$1
yum install -y git
git clone https://github.com/QingCloudAppcenter/Tomcat.git /opt/Tomcat

if [ -n "$gitBranch" ]
then
  git fetch origin $gitBranch:$gitBranch
  git checkout $gitBranch
  git branch --set-upstream-to=origin/$gitBranch $gitBranch
  git pull
fi

cp /opt/Tomcat/scripts/setupImage.sh /opt/setupImage.sh
/opt/setupImage.sh
