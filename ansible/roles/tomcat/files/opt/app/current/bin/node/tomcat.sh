initNode() {
  _initNode
  mkdir -p /data/tomcat/{war-listen,war-temp,webapps,logs}
  chown -R tomcat.svc /data/tomcat
  local htmlFile=/data/index.html; test -e "$htmlFile" || ln -s /opt/app/current/conf/caddy/index.html $htmlFile
}
