#! /bin/bash

tomcat_mgr_url="http://localhost:8080/manager/status?XML=true"
#access_user="qingAdmin"
#access_pwd="qing0pwd"
access_user=$1
access_pwd=$2
tmp_all_data="/tmp/all_data.xml"

wget -q --http-user="$access_user" --http-password="$access_pwd" "$tomcat_mgr_url" -O "$tmp_all_data"
python /opt/apache-tomcat/bin/get-monitor.py