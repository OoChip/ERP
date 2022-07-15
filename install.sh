#!/bin/sh
#Intall requeriments
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt-get -y install apt-utils  avahi-daemon git miniupnpc cron curl ca-certificates gnupg lsb-release docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER

#mDNS
sudo hostnamectl set-hostname erp
sudo update-rc.d avahi-daemon defaults
git clone https://github.com/OoChip/ERP.git && sudo mv ERP/services/* /etc/avahi/services/ && sudo /etc/init.d/avahi-daemon restart

#upnpc
sudo chmod +x ERP/upnp_ddns/script.sh && sudo mv ERP/upnp_ddns/script.sh /bin && sudo mv ERP/upnp_ddns/root /var/spool/cron/crontabs
sudo systemctl enable cron

#Portainer.
docker run -d -p 8000:8000 -p 81:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /:/host portainer/agent:2.10.0
