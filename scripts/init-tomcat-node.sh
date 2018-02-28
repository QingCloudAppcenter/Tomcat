#!/usr/bin/env bash
source "/opt/Tomcat/scripts/env.sh"
echo "Setting Java"
if [ "${ENV_JAVA_VERSION}" == "7" ] && [ "${ENV_TOMCAT_VERSION}" == "9" ];then
  echo "Tomcat 9 doesn't support Java 7"
  exit 101
fi
case "${ENV_JAVA_VERSION}" in
  "7")
  export PATH=/opt/jvm/java-se-7u75-ri/bin:$PATH
  export JAVA_HOME=/opt/jvm/java-se-7u75-ri
  ln -s -f /opt/jvm/java-se-7u75-ri/bin/javac /usr/bin/javac
  ln -s -f /opt/jvm/bin/javadoc /usr/bin/javadoc
  ln -s -f /opt/jvm/java-se-7u75-ri/bin/javah /usr/bin/javah
  ln -s -f /opt/jvm/java-se-7u75-ri/bin/javap /usr/bin/javap
  ;;
  "8")
  export PATH=/opt/jvm/jre1.8.0_172/bin:$PATH
  export JAVA_HOME=/opt/jvm/jre1.8.0_172
  ln -s -f /usr/lib/jvm/jre1.8.0_172/bin/javaws /usr/bin/javaws
  ;;
  "9")
  export PATH=/opt/jvm/jdk-9.0.4/bin:$PATH
  export JAVA_HOME=/opt/jvm/jdk-9.0.4
  ln -s -f /opt/jvm/jdk-9.0.4/bin/javac /usr/bin/javac
  ln -s -f /opt/jvm/jdk-9.0.4/bin/javadoc /usr/bin/javadoc
  ln -s -f /opt/jvm/jdk-9.0.4/bin/javah /usr/bin/javah
  ln -s -f /opt/jvm/jdk-9.0.4/bin/javap /usr/bin/javap
  ;;
  *)
  echo "Can't read Java version info from metadata"
  exit 102
  ;;
esac
case "${ENV_TOMCAT_VERSION}" in
  "7")
  ln -s -f /opt/TomcatVersions/apache-tomcat-7.0.85/* /opt/apache-tomcat/
  ;;
  "8")
  ln -s -f /opt/TomcatVersions/apache-tomcat-8.5.28/* /opt/apache-tomcat/
  ;;
  "9")
  ln -s -f /opt/TomcatVersions/apache-tomcat-9.0.5/* /opt/apache-tomcat/
  ;;
  *)
  echo "Can't read Tomcat version info from metadata"
  exit 103
  ;;
esac

systemctl restart rsyslog
mkdir -p /data/webapps
rsync -aqxP /opt/apache-tomcat/webapps/ /data/webapps