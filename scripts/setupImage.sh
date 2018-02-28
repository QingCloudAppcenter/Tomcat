#! /bin/bash

node_type=$1

# all nodes
unalias cp

yum install -y gcc
yum install -y python-devel
echo "install qing agent"
curl -o agent.tar.gz http://appcenter-docs.qingcloud.com/developer-guide/scripts/app-agent-linux-amd64.tar.gz
tar -xvf agent.tar.gz
cd /opt/app-agent-linux-amd64/
./install.sh
rm -rf agent.tar.gz
cd /opt

mkdir Tomcat
tar -xvf Tomcat.tar.gz -C /opt/Tomcat
rm -rf Tomcat.tar.gz

echo "modify the max notify limit"
#mv /etc/sysctl.d/max-users-watch.conf /etc/sysctl.d/max-users-watch.conf_bak
cp /opt/Tomcat/configuration/max-users-watch.conf /etc/sysctl.d
sysctl --system

echo "modify ulimit"
echo -ne " 
* soft nofile 65536 
* hard nofile 65536 
" >>/etc/security/limits.conf 

mv /etc/security/limits.conf /etc/security/limits.conf_bak
cp /opt/Tomcat/configuration/limits.conf /etc/security

echo "install zip unzip"
yum -y install zip unzip

echo "install net tools"
yum -y install net-tools


# tomcat node
if [ $node_type == "tomcat" ]
then
    echo "instal rsync"
    yum install -y rsync

    echo "install wget"
    yum -y install wget

    cd /opt/Tomcat
    echo "install openjdk7"
    #yum -y install java-1.8.0-openjdk
    curl -o jdk7.tar.gz https://download.java.net/openjdk/jdk7u75/ri/openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
    tar -xvf jdk7.tar.gz
    rm -rf jdk7.tar.gz
    echo "install openjdk8"
    curl -o jdk8.tar.gz https://download.java.net/java/jdk8u172/archive/b03/binaries/jre-8u172-ea-bin-b03-linux-x64-18_jan_2018.tar.gz
    tar -xvf jdk8.tar.gz
    rm -rf jdk8.tar.gz
    echo "install openjdk9"
    curl -o jdk9.tar.gz https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz
    tar -xvf jdk9.tar.gz
    rm -rf jdk9.tar.gz

    echo "install tomcat7"
    curl -o tomcat.tar.gz http://mirrors.shu.edu.cn/apache/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz
    tar -xvf tomcat.tar.gz
    rm -rf tomcat.tar.gz

    echo "install tomcat8"
    curl -o tomcat.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz
    tar -xvf tomcat.tar.gz
    rm -rf tomcat.tar.gz

    echo "install tomcat9"
    curl -o tomcat.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.5/bin/apache-tomcat-9.0.5.tar.gz
    tar -xvf tomcat.tar.gz
    rm -rf tomcat.tar.gz

    echo "deploy scripts and templates"

    mkdir /var/log/tomcat
    mkdir /tmp/war-listen
    mkdir /tmp/war-temp
    mkdir /root/.qingstor


    echo "install pyinotify"
    tar -xvf /opt/Tomcat/configuration/tomcat_node/pyinotify.tar.gz
    cd /opt/Tomcat/configuration/tomcat_node/pyinotify
    python setup.py install
    cd /opt
    rm -rf pyinotify.tar.gz
    rm -rf pyinotify/
    cp /opt/Tomcat/configuration/tomcat_node/tomcat_gc_log.conf /etc/rsyslog.d
    chmod +x /opt/Tomcat/scripts/*.sh
    mv /opt/apache-tomcat-7.0.85/bin/catalina.sh /opt/apache-tomcat-7.0.85/bin/catalina.sh_bak
    cp /opt/Tomcat/scripts/*.sh /opt/apache-tomcat-7.0.85/bin
    cp /opt/Tomcat/scripts/*.py /opt/apache-tomcat-7.0.85/bin
    rm -rf /opt/apache-tomcat-7.0.85/bin/catalina.properties
    cp /opt/Tomcat/catalina.properties /opt/apache-tomcat-7.0.85/conf
    cp /opt/Tomcat/lib/*.jar /opt/apache-tomcat-7.0.85/lib
    rm -rf /opt/apache-tomcat-7.0.85/lib/tomcat-juli.jar
    mv /opt/apache-tomcat-7.0.85/bin/tomcat-juli.jar /opt/apache-tomcat-7.0.85/bin/tomcat-juli.jar_bak
    cp /opt/Tomcat/lib/tomcat-juli.jar /opt/apache-tomcat-7.0.85/bin/
    mv /opt/apache-tomcat-7.0.85/conf/logging.properties /opt/apache-tomcat-7.0.85/conf/logging.properties_bak
    cp /opt/Tomcat/code/tomcat_node/conf.d/*.toml /etc/confd/conf.d
    cp /opt/Tomcat/code/tomcat_node/template/*.tmpl /etc/confd/templates
    rm -rf /opt/Tomcat

    echo "install pip"
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    python get-pip.py

    echo "install qsctl"
    pip install qsctl -U
    rm -rf /opt/get-pip.py
fi

# log server node
if [ $node_type == "log" ]
then 
    cd /opt
    mv /etc/rsyslog.conf /etc/rsyslog.conf_bak
    cp /opt/Tomcat/configuration/log_node/rsyslog.conf /etc/
    cp /opt/Tomcat/code/log_node/conf.d/*.toml /etc/confd/conf.d
    cp /opt/Tomcat/code/log_node/template/*.tmpl /etc/confd/templates
    rm -rf /opt/Tomcat
fi

#jenkins node
#wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
#rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#yum install jenkins



