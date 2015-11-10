#!/bin/bash
set -e

INTERFACE="${INTERFACE:-docker0}"
PORTSDNS="${PORTSDNS:-53}"
PORTSHTTP="${PORTSHTTP:-80, 8080, 8000, 5000, 8002}"
PORTSMEMCACHE="${PORTSMEMCACHE:-11211}"
PORTSMYSQL="${PORTSMYSQL:-3306}"
PORTSPGSQL="${PORTSPGSQL:-5432}"
PORTSREDIS="${PORTSREDIS:-6379}"
PORTSTHRIFT="${PORTSTHRIFT:-9090}"
PORTSMONGODB="${PORTSMONGODB:-27017}"
ELASTICENABLED="${ELASTICENABLED:-true}"
ELASTICHOSTS="${ELASTICHOSTS:-\"localhost:9200\"}"
LOGSTASHENABLED="${LOGSTASHENABLED:-false}"
LOGSTASHHOSTS="${LOGSTASHHOSTS:-\"localhost:5044\", \"logstash:5045\"}"
FILEENABLED="${FILEENABLED:-false}"
FILEPATH="${FILEPATH:-\"/tmp/packetbeat\"}"
GEOIPPATH="${GEOIPPATH:-\"/usr/local/share/GeoIP/GeoIP.dat\"}"

CONFIGFILE=/etc/packetbeat/packetbeat.yml
sed 's|{{INTERFACE}}|'"${INTERFACE}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSDNS}}|'"${PORTSDNS}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSHTTP}}|'"${PORTSHTTP}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSMEMCACHE}}|'"${PORTSMEMCACHE}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSMYSQL}}|'"${PORTSMYSQL}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSPGSQL}}|'"${PORTSPGSQL}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSREDIS}}|'"${PORTSREDIS}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSTHRIFT}}|'"${PORTSTHRIFT}"'|' -i "$CONFIGFILE"
sed 's|{{PORTSMONGODB}}|'"${PORTSMONGODB}"'|' -i "$CONFIGFILE"
sed 's|{{ELASTICENABLED}}|'"${ELASTICENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{ELASTICHOSTS}}|'"${ELASTICHOSTS}"'|' -i "$CONFIGFILE"
sed 's|{{LOGSTASHENABLED}}|'"${LOGSTASHENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{LOGSTASHHOSTS}}|'"${LOGSTASHHOSTS}"'|' -i "$CONFIGFILE"
sed 's|{{FILEENABLED}}|'"${FILEENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{FILEPATH}}|'"${FILEPATH}"'|' -i "$CONFIGFILE"
sed 's|{{GEOIPPATH}}|'"${GEOIPPATH}"'|' -i "$CONFIGFILE"

# Kibana Dashboards
for es in $(echo "${ELASTICHOSTS}" | sed 's|,\s*| |g'); do
  # strip "
  ses=$(echo $es | tr -d '"')

  # check if already present in ES
  status=$(curl -i -XHEAD "http://${ses}/packetbeat-*" 2>/dev/null | egrep "HTTP\/1\..?" | cut -d ' ' -f 2)
  status=${status:-200}

  # add dashboards if not already loaded
  if((${status}!=200)); then
    if [ ! -f /tmp/master.zip ]; then
      curl -L -o /tmp/master.zip https://github.com/elastic/beats-dashboards/archive/master.zip
      unzip /tmp/master.zip -d /tmp
    fi
    cd /tmp/beats-dashboards-master/
    ./load.sh "http://$ses"
  fi
done

case ${1} in
  app:start)
    packetbeat -e -c ${CONFIGFILE}
    ;;
  *)
    /bin/sh -c ${1}
    ;;
esac

exit 0
