#!/bin/bash
#by Walid MAdkour
PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`
chilli=`chilli_query list |grep pass -c`
if [[ $GROUPZ == *irc* ]]; then
ENDSESSION=`cat /etc/security/limits.conf | grep "@irc" | grep maxlogins | awk {'print $4'}`
PRIVLAGED="IRC Account"
else
ENDSESSION="Unlimited"
PRIVLAGED="Regular User"
fi
echo -e "
\033[0;35m+++++++++++++++++: \033[0;37mSystem Data\033[0;35m :+++++++++++++++++++
+\033[0;37mHostname \033[0;35m= \033[1;32m`hostname`
\033[0;35m+\033[0;37mKernel \033[0;35m= \033[1;32m`uname -r`
\033[0;35m+\033[0;37mO.S Verision \033[0;35m= \033[1;32m`cat /etc/centos-release`
+\033[0;37mSystem Uptime \033[0;35m= \033[1;32m`uptime | awk '{print $3,$4}' | cut -f1 -d,`
\033[0;35m+\033[0;37mCPU \033[0;35m= \033[1;32m4x `cat  /proc/cpuinfo |grep -i "model name" |uniq |cut -d':' -f2`
\033[0;35m+\033[0;37mMemory \033[0;35m= \033[1;32m`free -m | head -n 2 | tail -n 1 | awk {'print $2'}` Mb
\033[0;35m+\033[0;37mMemory free(real) \033[0;35m= \033[1;32m`free -m | head -n 2 | tail -n 1 | awk {'print $4'}` Mb
\033[0;35m+\033[0;37mMemory free(cache) \033[0;35m= \033[1;32`free -m | head -n 3 | tail -n 1 | awk {'print $3'}` Mb
\033[0;35m+\033[0;37mSwap in use \033[0;35m= \033[1;32m`free -m | tail -n 1 | awk {'print $3'}` Mb
\033[0;35m+++++++++++++++++: \033[0;37mNetwork\033[0;35m :+++++++++++++++++++++++
+\033[0;37minternalip \033[0;35m= \033[1;32m`hostname -I`
+\033[0;37mCheck DNS\033[0;35m= \033[1;32m`cat /etc/resolv.conf | sed '1 d' | awk '{print $2}'`
\033[0;35m+\033[0;37mIP POOL \033[0;35m= \033[1;32m`chilli_query listippool |grep Dynamic\ address`
\033[0;35m++++++++++++++++++: \033[0;37mUser Data\033[0;35m :++++++++++++++++++++
+\033[0;37mUsername \033[0;35m= \033[1;32m`whoami`
\033[0;35m+\033[0;37mPrivlages \033[0;35m= \033[1;32m$PRIVLAGED
\033[0;35m+\033[0;37mSessions \033[0;35m= \033[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\033[0;35m+\033[0;37mProcesses \033[0;35m= \033[1;32m$PROCCOUNT of `ulimit -u` MAX
\033[0;35m++++++++++++: \033[0;31mUSERS Information\033[0;35m :+++++++++++++++++
\033[0;35m+    \033[0;37mONLINE \033[0;35m= \033[1;32m`chilli_query list |grep pass -c`
\033[0;35m+    \033[0;37mD-NAT \033[0;35m= \033[1;32m`chilli_query list |grep dnat -c`
\033[0;35m++++++: \033[0;37mCheck if connected to Internet or not\033[0;35m :+++++++++
`ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $walidmadkour Connected" || echo -e '\E[32m'"Internet: $walidmadkour Disconnected"`
\033[0;35m+++++++++++++++++++++++++++++++++++++++++++++++++++ \033[0;37m
