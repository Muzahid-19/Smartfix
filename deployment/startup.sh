#!/bin/sh
set -eu

: "${SMARTFIX_DB_PASSWORD:?Database password is missing}"
: "${SMARTFIX_DB_TRUSTSTORE_PASSWORD:?Truststore password is missing}"

SOURCE_FILE="/etc/secrets/aiven-truststore-base64.txt"
TRUSTSTORE_FILE="/tmp/aiven-truststore.jks"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "ERROR: Base64 truststore secret file not found at $SOURCE_FILE"
  exit 1
fi

sed '/-----BEGIN CERTIFICATE-----/d; /-----END CERTIFICATE-----/d; /^$/d' "$SOURCE_FILE" \
  | base64 -d > "$TRUSTSTORE_FILE"

if [ ! -s "$TRUSTSTORE_FILE" ]; then
  echo "ERROR: Decoded truststore file is empty."
  exit 1
fi

export CATALINA_OPTS="${CATALINA_OPTS:-} -DSMARTFIX_DB_PASSWORD=${SMARTFIX_DB_PASSWORD} -DSMARTFIX_DB_CA=${TRUSTSTORE_FILE} -DSMARTFIX_DB_TRUSTSTORE_PASSWORD=${SMARTFIX_DB_TRUSTSTORE_PASSWORD}"

exec catalina.sh run