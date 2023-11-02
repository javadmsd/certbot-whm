#!/bin/bash

DIR="$(dirname "$0")"
source "$DIR/config.sh"

echo "CHALLENGE_DOMAIN: ${RECORD_DOMAIN}"
echo "CHALLENGE_VALUE: ${CERTBOT_VALIDATION}"

PAYLOAD="class=IN&domain=$RECORD_DOMAIN&name=$RECORD_NAME&ttl=$TTL&type=$RECORD_TYPE&txtdata=$CERTBOT_VALIDATION"

RESPONSE=$(curl -s -X POST "https://$WHM_SERVER:2087/$WHM_CPSESS/json-api/addzonerecord" \
    -H "Authorization: whm $WHM_USERNAME:$WHM_TOKEN" \
    -d "$PAYLOAD" \
    --insecure)

echo "$RESPONSE"

attempt_counter=0
while true; do
    if [[ $attempt_counter = $MAX_ATTEMPTS ]]; then
        echo "DNS propagation time: $(($attempt_counter * $SLEEP_TIME))s"
        echo "Max attempts reached. The creation of the Let's Encrypt certificate (with DNS verification) will fail"
        break
    fi

    for d in $(dig "@$DNS_SERVER" -t txt +short "$RECORD_NAME.$RECORD_DOMAIN"); do
        if [[ "$d" = "\"$CERTBOT_VALIDATION\"" ]]; then
            echo "DNS propagation time: $(($attempt_counter * $SLEEP_TIME))s"
            break 2
        fi
    done

    attempt_counter=$(($attempt_counter + 1))

    # Sleep to make sure the change has time to propagate over to DNS
    sleep $SLEEP_TIME
done
