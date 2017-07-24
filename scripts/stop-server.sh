#! /bin/bash
/opt/apache-tomcat-7.0.78/bin/catalina.sh stop
tomcatProcesses=$(ps x |grep catalina |grep tomcat |grep -v grep)
if [ -n "$tomcatProcesses" ]
then
#echo "there are still tomcat running, kill them all"
  ps -ef|grep catalina |grep tomcat |grep -v grep|cut -c 9-15|xargs kill -9
fi