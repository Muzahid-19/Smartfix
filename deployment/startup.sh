
#!/bin/sh
set -eu

: "${SMARTFIX_DB_PASSWORD:?Database password is missing}"
: "${SMARTFIX_DB_TRUSTSTORE_PASSWORD:?Truststore password is missing}"
: "${SMARTFIX_DB_CA:?Truststore path is missing}"

if [ ! -f "$SMARTFIX_DB_CA" ]; then
  echo "ERROR: Aiven truststore file not found."
  exit 1
fi

export CATALINA_OPTS="${CATALINA_OPTS:-} -DSMARTFIX_DB_PASSWORD=${SMARTFIX_DB_PASSWORD} -DSMARTFIX_DB_CA=${SMARTFIX_DB_CA} -DSMARTFIX_DB_TRUSTSTORE_PASSWORD=${SMARTFIX_DB_TRUSTSTORE_PASSWORD}"

exec catalina.sh run
