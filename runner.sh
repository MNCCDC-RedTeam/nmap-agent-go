#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "[-] Please run as root"
  exit
fi

while true
do
	./nmap-agent-go;

	# Generate octets within 10.0.0.0/8 range reserving top 5 address
	o1=10;
	o2=$[ $RANDOM % 255 + 1];
	o3=$[ $RANDOM % 255 + 1];
	o4=$[ $RANDOM % 250 + 1];
	interface=eth0;

	# Change network information after each run
	nmcli con modify $interface ipv4.addresses 10.$o2.$o3.$o4/8;
	nmcli con modify $interface ipv4.gateway 10.0.0.1;
	nmcli con modify $interface ipv4.dns "1.1.1.1 8.8.8.8 8.8.4.4";
	nmcli con modify $interface ipv4.method manual;
	nmcli con down $interface && nmcli con up $interface;
done
