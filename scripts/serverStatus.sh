#! /bin/bash
# check if server port is ready
port_status=$(netstat -tulpen | grep 8080)
#echo $port_status
if [ "$port_status" != "" ]
then
    portReady=true
else
    portReady=false
fi
#echo $portReady
# check if tomcat process is running
process_status=$(ps -ef | grep -v grep | grep 'tomcat\|java')
#echo $process_status
if [ "$process_status" != "" ]
then
    pidReady=true
else
    pidReady=false
fi
#echo $pidReady
# check if tomcat default web module is running
response_code=$(curl -m 20 -s -o /dev/null -I -w "%{http_code}" http://localhost:8080/)
#echo $response_code

if [ $portReady == "true" ]&&[ $pidReady == "true" ]&&[ $response_code == "200" ]
then
    exit 0
elif [ $portReady == "true" ]&&[ $pidReady == "true" ]
then
    exit 2
else
    exit 1
fi
