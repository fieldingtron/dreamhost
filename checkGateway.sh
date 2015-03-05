#!/bin/bash
echo "testing for 502 gateway";
P="$(curl -s http://websitetotest.com |grep "502 Bad Gateway" | wc -l)";
if test $P -gt 0
then
	##  positive match  Gateway error found
	echo "Gateway 502 error found";

	####
	#### Send message before reboot via PUSHover.net
	#### Notify Cellphone
	####
	APP_TOKEN=xxxxxx
	USER_KEY=yyyyyyy
	MESSAGE='502 Gateway Error Server will be rebooted'

	curl -s \
 	 --form-string "token=$APP_TOKEN" \
	 --form-string "user=$USER_KEY" \
 	 --form-string "message=$MESSAGE" \
  	https://api.pushover.net/1/messages.json
	####
	#### now reboot via the  api
	####
	PS=yyyyyyy
	KEY=zzzzzzzzz
	UUID=`dbus-uuidgen`
	CMD=dreamhost_ps-reboot
	LINK="https://api.dreamhost.com/?key=$KEY&unique_id=$UUID&cmd=$CMD&ps=$PS"
	RESPONSE=`wget -O- -q "$LINK"`
	echo "$LINK"
	echo "$RESPONSE"
	if ! (echo $RESPONSE | grep -q 'success'); then
        exit 1
	fi

else
	echo "No Gateway errors found"; 		
fi
