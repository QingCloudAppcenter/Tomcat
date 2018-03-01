#! /bin/bash
source /opt/Tomcat/scripts/env.sh

if [ ! -d "/data/webapps" ] || [ ! -d "/opt/apache-tomcat/bin" ]
then
  exit 0
fi

# sync tomcat config files
cp -rf /opt/Tomcat/configuration/tomcat_node/context.xml /opt/apache-tomcat/conf/context.xml
cp -rf /opt/Tomcat/configuration/tomcat_node/server.xml /opt/apache-tomcat/conf/server.xml
cp -rf /opt/Tomcat/configuration/tomcat_node/tomcat-users.xml /opt/apache-tomcat/conf/tomcat-users.xml
cp -rf /opt/Tomcat/configuration/tomcat_node/log4j.properties /opt/apache-tomcat/lib/log4j.properties
cp -rf /opt/Tomcat/scripts/get-monitor.sh /opt/apache-tomcat/bin/get-monitor.sh
cp -rf /opt/Tomcat/scripts/get-war.sh /opt/apache-tomcat/bin/get-war.sh
cp -rf /opt/Tomcat/scripts/setupenv.sh /opt/apache-tomcat/bin/setupenv.sh
case "${ENV_TOMCAT_VERSION}" in
  "7")
  cp -rf /opt/Tomcat/configuration/tomcat_node/v7/catalina.properties /opt/apache-tomcat/conf/catalina.properties
  ;;
  "8")
  cp -rf /opt/Tomcat/configuration/tomcat_node/v8/catalina.properties /opt/apache-tomcat/conf/catalina.properties
  ;;
  "9")
  cp -rf /opt/Tomcat/configuration/tomcat_node/v9/catalina.properties /opt/apache-tomcat/conf/catalina.properties
  ;;
  *)
  echo "Can't read Tomcat version info from metadata"
  exit 103
  ;;
esac

/opt/apache-tomcat/bin/check-multicast.sh
/opt/apache-tomcat/bin/get-war.sh

/opt/apache-tomcat/bin/serverStatus.sh
#echo $?
serverStatus=$?
if [ $serverStatus == "0" ]
then
  #echo "server is running"
  /opt/apache-tomcat/bin/catalina.sh stop
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
/opt/apache-tomcat/bin/catalina.sh start
