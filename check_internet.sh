#!/bin/bash
#chmod +x check_inet.sh
#* * * * * root /root/check_inet.sh

TMP_FILE=/tmp/inet_up

# Edit this function if you want to do something besides reboot
no_inet_action() {
	/etc/init.d/network restart 'No internet.' 
}

if ping -c5 google.com; then
    echo 1 > $TMP_FILE
else
    [[ `cat $TMP_FILE` == 0 ]] && no_inet_action || echo 0 > $TMP_FILE
fi

chmod +x check_inet.sh

* * * * * root /root/check_inet.sh
