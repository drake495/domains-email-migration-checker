#!/bin/bash

RED="\e[0;31m"
GREEN="\e[1;32m"
NORMAL="\e[0m"
clear
echo "How many IP's are on the old server?"
read oldnumber
i=0
touch oldserverip.txt
while [ $i -lt $oldnumber ]; do 
 (( i++ )) 
echo "Please enter the next IP address of the old server"
read oldserverip
echo "$oldserverip" >> oldserverip.txt
done

echo " "
echo "Old server IPs noted."
echo " "
echo " "
echo "How many IP's are on the new server?" 
read newnumber
t=0
touch newserverip.txt
while [ $t -lt $newnumber ]; do 
  (( t++ ))
echo "Please enter the next IP address of the new server"
read newserverip
echo "$newserverip" >> newserverip.txt
done
echo " "
echo "New server IPs noted."
echo " "
echo " "


####  Input of old and new IPs complete and writing to text files. 
#
#
#  Next step is to have it read the variables from the text files and compare the IPs.
#
#




for name in $(cat domains.txt);do
#
#This part does the IP address lookup and compare to the servers
#
#
ipadd=` host $name | grep "has address" | awk {'print $4'}`
host $name

# attempting nested for loops.  this could get messy.

for oldserver in $(cat oldserverip.txt);do

      if [ "$ipadd" = "$oldserver" ]; then 
        echo -e "$name is resolving to the: ${RED} OLD SERVER ${NORMAL}"
      fi
done

for newserver in $(cat newserverip.txt);do
   if [ "$ipadd" = "$newserver" ]; then
	echo -e "$name is resolving to the:  ${GREEN} NEW SERVER ${NORMAL}" 
    fi
done
#
#
# This part does the mx record lookup and compare to the servers 
# needs to be updated to pull the mx and not just mail.$variable 
#
#
ipadd2=`dig +short mail.$name`
echo "mail.$name resolves to the following server: `dig +short mail.$name`"

for oldserver in $(cat oldserverip.txt);do
if [ "$ipadd2" = "$oldserver" ]; then
        echo -e "mail.$name is resolving to the: ${RED} OLD SERVER ${NORMAL}"
fi
done

for newserver in $(cat newserverip.txt);do
    if [ "$ipadd2" = "$newserver" ]; then
        echo -e "mail.$name is resolving to the:  ${GREEN} NEW SERVER ${NORMAL}"
fi
done
echo " "
done

echo " "
echo "Do you want to remove the temporary files created by this script?  [Y/N]"
read answer
if [ "$answer" = "y" ]; then
    rm -f newserverip.txt
    rm -f oldserverip.txt
else 
   echo "Goodbye."
fi




