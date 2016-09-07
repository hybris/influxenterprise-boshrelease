#!/bin/sh
DEBUG=true
WARNING_DAYS=${WARNING_DAYS:-90} # Number of days to warn about soon-to-expire certs
CERTS_TO_CHECK=${CERTS_TO_CHECK:-'api.stage.yaas.io:443,api.yaas.io:443'}
VO_API_KEY=${VO_API_KEY:-'please-set-api-key'}
VO_ROUTING_KEY=${VO_ROUTING_KEY:-'default'}

IFS=", "
for CERT in $CERTS_TO_CHECK
do
  $DEBUG && echo "Checking cert: [$CERT]"
  output=$(echo | openssl s_client -connect ${CERT} 2>/dev/null | openssl x509 -noout -dates | grep notAfter)

  if [ "$?" -ne 0 ]; then
    $DEBUG && echo "Error connecting to host for cert [$CERT]"
    curl --data-binary "{\"message_type\":\"critical\",\"timestamp\":\"$(date +%s)\",\"entity_id\":\"Error connecting to host for cert [$CERT]\"}" \
      https://alert.victorops.com/integrations/generic/20131114/alert/${VO_API_KEY}/${VO_ROUTING_KEY}

    # exit 1
    continue
  fi

  end_date=$(echo $output | sed 's/.*notAfter=//')

  end_epoch=$(date +%s -d "$end_date")

  epoch_now=$(date +%s)


  seconds_to_expire=$(($end_epoch - $epoch_now))
  days_to_expire=$(($seconds_to_expire / 86400))

  $DEBUG && echo "Days to expiry: ($days_to_expire)"

  warning_seconds=$((86400 * $WARNING_DAYS))

  if [ "$seconds_to_expire" -lt "$warning_seconds" ]; then
    $DEBUG && echo "Cert [$CERT] is soon to expire ($seconds_to_expire seconds)"
    curl --data-binary "{\"message_type\":\"critical\",\"timestamp\":\"$(date +%s)\",\"entity_id\":\"Cert [$(echo | openssl s_client -connect $CERT 2>/dev/null | openssl x509 -noout -subject), $CERT] is soon to expire ('$days_to_expire' days)\"}" \
        https://alert.victorops.com/integrations/generic/20131114/alert/${VO_API_KEY}/${VO_ROUTING_KEY}
  fi
done
