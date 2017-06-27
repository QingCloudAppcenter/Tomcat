#! /bin/bash

echo "install wget"
yum -y install wget

echo "install openjdk"
yum -y install java-1.8.0-openjdk

echo "install qing agent"
curl -o agent.tar.gz https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz
tar -xvf agent.tar.gz
cd /opt/app-agent-linux-amd64/
./install.sh
rm -rf agent.tar.gz
cd /opt

echo "install pyinotify"
tar -xvf pyinotify.tar.gz
cd 

echo "install tomcat"
curl -o tomcat.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-7/v7.0.78/bin/apache-tomcat-7.0.78.tar.gz
tar -xvf tomcat.tar.gz
rm -rf tomcat.tar.gz

echo "install net tools"
yum -y install net-tools
echo "deploy scripts and templates"

mkdir /tmp/war-listen
mkdir /tmp/war-temp
mkdir /root/.qingstor
mkdir tomcat_app
tar -xvf tomcat_app.tar.gz -C /opt/tomcat_app
rm -rf tomcat_app.tar.gz
chmod +x /opt/tomcat_app/scripts/*.sh
cp /opt/tomcat_app/scripts/*.* /opt/apache-tomcat-7.0.78/bin
cp /opt/tomcat_app/lib/*.jar /opt/apache-tomcat-7.0.78/lib
cp /opt/tomcat_app/code/conf.d/*.toml /etc/confd/conf.d
cp /opt/tomcat_app/code/template/*.tmpl /etc/confd/templates
rm -rf /opt/tomcat_app

echo "install pip"
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py

echo "install qsctl"
pip install qsctl -U
rm -rf /opt/get-pip.py


#wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
#rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#yum install jenkins
