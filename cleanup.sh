#!/bin/bash

DIR="$(dirname "$0")"
source "$DIR/config.sh"

echo "DOMAIN: ${RECORD_DOMAIN}"

RECORDS=$(curl -X GET "https://$WHM_SERVER:2087/$WHM_CPSESS/json-api/dumpzone?api.version=1&domain=$RECORD_DOMAIN" \
    -H "Authorization: whm $WHM_USERNAME:$WHM_TOKEN" \
    --insecure)

RECORD_LINE=$(echo "$RECORDS" | jq -r '.data.zone[].record[] | select(.type == "TXT" and .name == "'"$RECORD_NAME.$RECORD_DOMAIN."'").Line')

if [[ -n "$RECORD_LINE" ]]; then
    RESPONSE=$(curl -X GET "https://$WHM_SERVER:2087/$WHM_CPSESS/json-api/removezonerecord?api.version=1&zone=$RECORD_DOMAIN&line=$RECORD_LINE" \
        -H "Authorization: whm $WHM_USERNAME:$WHM_TOKEN" \
        --insecure)

    echo "Removed record at line index $RECORD_LINE"
else
    echo "No matching TXT record found for removal."
fi
