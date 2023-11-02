WHM_USERNAME="xxxx"
WHM_SERVER="xxx.xxx.xxx.xxx"
WHM_CPSESS="cpsessxxxxxxxxxxx"
WHM_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxx"

RECORD_DOMAIN=$(sed 's/.*\.\(.*\..*\)/\1/' <<< "${CERTBOT_DOMAIN}")
RECORD_NAME="_acme-challenge"
RECORD_TYPE="TXT"
TTL=120

# Google
DNS_SERVER="8.8.8.8"

MAX_ATTEMPTS=120
SLEEP_TIME=5
# Total time to wait for DNS propagation = max_attempts * sleep_time = 120 * 5s = 600s = 10 min
