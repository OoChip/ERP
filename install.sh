#!/bin/sh
#Intall requeriments
sudo mkdir -p /etc/apt/keyrings
sudo apt install -y curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /etc/apt/keyrings/jcameron-key.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo \
  "deb [signed-by=/etc/apt/keyrings/jcameron-key.gpg] https://download.webmin.com/download/repository sarge contrib" \
  | sudo tee /etc/apt/sources.list.d/webmin.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt -y install apt-utils  avahi-daemon git miniupnpc cron ca-certificates gnupg lsb-release apt-transport-https webmin \
  docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker systemd-timesyncd 
sudo usermod -aG docker $USER

#RTC
sudo timedatectl set-timezone "America/Caracas" && timedatectl set-local-rtc 1 && timedatectl set-ntp true


#mDNS
sudo hostnamectl set-hostname erp
sudo update-rc.d avahi-daemon defaults
git clone https://github.com/OoChip/ERP.git && sudo mv ERP/services/* /etc/avahi/services/ && sudo /etc/init.d/avahi-daemon restart

#upnpc
sudo chmod +x ERP/upnp_ddns/script.sh && sudo mv ERP/upnp_ddns/script.sh /bin && sudo mv ERP/upnp_ddns/oochip /var/spool/cron/crontabs/oochip
sudo systemctl enable cron
sudo rm -rf ERP

#Portainer.
docker run -d -p 8000:8000 -p 82:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /:/host portainer/agent:latest

curl -L https://install.pivpn.io | bash
