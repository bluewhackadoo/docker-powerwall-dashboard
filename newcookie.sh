#!/bin/bash

curl https://192.168.2.185/api/login/Basic -k -s -i -X POST -H 'Content-Type: application/json' -d '{"username":"customer", "password":"'$TSLAPASS'", "email":"'$TSLAUSER'", "force_sm_off":false}' -c /tmp/cookie.txt

auth=$(grep -o -P '(?<=AuthCookie\s)([\w|\-|\d|\=]+)' /tmp/cookie.txt)
userrec=$(grep -o -P '(?<=UserRecord\s)([\w|\-|\d|\=]+)' /tmp/cookie.txt)
export TSLA_COOKIE=$(echo "{\"Cookie\" = \"AuthCookie=$auth; UserRecord=$userrec\"}")

