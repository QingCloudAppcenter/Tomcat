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

measure() {
  curl -m3 -sL -u "tomcat:$TOMCAT_PASSWORD" "localhost:8080/manager/status?XML=true" | 
    grep -o "<connector.*</connector>" |
    egrep -o "(name|currentThreadCount|currentThreadsBusy|maxTime|requestCount)=[^ >]*" |
    sed 's/"//g; s/=/: /g; s/^name/connector/g; s/^/http_/g' |
    yq r -j -
}

installWebApps() {
  local webapps; webapps="$(echo $@ | jq -r '.webapps')"
  local war; for war in ${webapps//,/ }; do
    installWebApp $war
  done
}

installWebApp() {
  local targetPath=/data/tomcat/webapps/$1
  if test -d $targetPath; then return 0; fi
  sudo -u tomcat cp -r /opt/tomcat/current/webapps/$1 $targetPath
}

getFirstNode() {
  local firstNode=${STABLE_NODES%% *}
  echo -n ${firstNode##*/} | jq -Rsc '{labels: ["ip"], data: [[.]]}'
}
