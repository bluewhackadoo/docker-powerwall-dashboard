#!/bin/bash

curl https://teslapw/api/login/Basic -k -s -i -X POST -H 'Content-Type: application/json' -d '{"username":"customer", "password":"'$TSLAPASS'", "email":"'$TSLAUSER'", "force_sm_off":false}' -c /tmp/cookie.txt

auth=$(grep -o -P '(?<=AuthCookie\s)([\w|\-|\d|\=]+)' /tmp/cookie.txt)
userrec=$(grep -o -P '(?<=UserRecord\s)([\w|\-|\d|\=]+)' /tmp/cookie.txt)
TSLA_COOKIE=$(echo {\"Cookie\" = \"AuthCookie=$auth\; UserRecord=$userrec\"})

# Replace the cookie in powerwall.conf since influxd gets confused by the chars if we try to do env expansion from TSLA_COOKIE
sed -i -e 's/ headers.*/headers = \'"$TSLA_COOKIE"'/g' /etc/telegraf/telegraf.d/powerwall.conf
