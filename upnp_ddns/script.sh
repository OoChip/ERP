#!/bin/bash
#/bin/script.sh

#DuckDNS
ddns_domain=donelias1
ddns_token=473fba06-f1d5-4dc8-850d-e0fbba0748f4
ddns_update=$(curl -fsSL https://duckdns.org/update/{$ddns_domain}/{$ddns_token}/)
echo
echo DDNS Update: $ddns_update

#UPnP
upnpc -s > upnp.txt
lan_ip=$(cat upnp.txt | grep ^"Local LAN ip address" | cut -c24-)
wan_ip=$(cat upnp.txt | grep ^ExternalIPAddress | cut -c21-)
public_ip=$(curl -fsSL https://ipinfo.io/ip)
router_ip=$(cat upnp.txt | grep ^" desc: http://" | cut -c15-25)
igd_port=$(cat upnp.txt | grep ^" desc: http://" | cut -c27-30)
igd_desc_url=$(cat upnp.txt | grep ^" desc:" | cut -c8-)
igd_control_url=$(cat upnp.txt | grep ^"Found a (not connected?) IGD : " | cut -c32-)

echo
echo Lan Ip: $lan_ip
echo Wan Ip: $wan_ip
echo Public Ip: $public_ip
echo Router Ip: $router_ip
echo IGD Port: $igd_port
echo IGD Desc Url: $igd_desc_url
echo IGD Control Url: $igd_control_url
echo

external_port=23
internal_port=23
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "SSH" -a $lan_ip $internal_port $external_port TCP > /dev/null

external_port=80
internal_port=80
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "HTTP" -a $lan_ip $internal_port $external_port TCP > /dev/null

external_port=81
internal_port=81
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "NPM" -a $lan_ip $internal_port $external_port TCP > /dev/null

external_port=82
internal_port=82
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "Portainer" -a $lan_ip $internal_port $external_port TCP > /dev/null

external_port=443
internal_port=443
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "HTTPS" -a $lan_ip $internal_port $external_port TCP > /dev/null

external_port=51820
internal_port=51820
upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
upnpc -u  $igd_desc_url -e "PiVPN" -a $lan_ip $internal_port $external_port TCP > /dev/null

upnpc -l | sed '1,16d' | sed '$d'

