#! /bin/bash
/opt/apache-tomcat-7.0.78/bin/check-multicast.sh
/opt/apache-tomcat-7.0.78/bin/serverStatus.sh
/opt/apache-tomcat-7.0.78/bin/get-war.sh
#echo $?
serverStatus=$?
if [ $serverStatus == "0" ]
then
  #echo "server is running"
  /opt/apache-tomcat-7.0.78/bin/catalina.sh stop
  tomcatProcesses=$(ps x |grep catalina |grep tomcat |grep -v grep)
  if [ -n "$tomcatProcesses" ]
  then
    #echo "there are still tomcat running, kill them all"
    ps -ef|grep catalina |grep tomcat |grep -v grep|cut -c 9-15|xargs kill -9
  fi
elif [ $serverStatus == "2" ]
then
   #echo "server is still starting"
   pid=$(ps x |grep catalina |grep tomcat |grep -v grep|awk '{print $1}')
   kill -9 $pid
fi
tomcatProcesses=$(ps x |grep catalina |grep tomcat |grep -v grep)
if [ -n "$tomcatProcesses" ]
then
  #echo "there are still tomcat running, kill them all"
  ps -ef|grep catalina |grep tomcat |grep -v grep|cut -c 9-15|xargs kill -9 
fi
#echo "server is down"
/opt/apache-tomcat-7.0.78/bin/catalina.sh start
