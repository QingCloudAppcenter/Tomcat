#! /bin/bash
# chkconfig: 0123456 10 90 
# description: service to check if multicase route is existed in network
# Check if the default multicast route existed in network
if route | grep -q 228.0.0.4
then
        routeExisted=true
else
        routeExisted=false
fi
#echo $routeExisted
# Add the default multicast route as it is not existed in network
if [ $routeExisted == "false" ]
then
        route add -host 228.0.0.4 dev eth0
fi
