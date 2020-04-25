initNode() {
  _initNode
  mkdir -p /data/tomcat/{war-listen,war-temp,webapps,logs}
  chown -R tomcat.svc /data/tomcat
  ln -snf $JAVA_VERSION /opt/jdk/current
  ln -snf $TOMCAT_VERSION /opt/tomcat/current
  local defaultConfDir=/opt/tomcat/current/conf
  local confDir=/opt/app/current/conf/tomcat
  local fileName; for fileName in $(ls $defaultConfDir); do
    [ -e "$confDir/$fileName" ] || ln -s $defaultConfDir/$fileName $confDir/$fileName
  done
  ln -snf $confDir /data/tomcat/conf
  local htmlFile=/data/index.html; test -e "$htmlFile" || ln -s /opt/app/current/conf/caddy/index.html $htmlFile
}
