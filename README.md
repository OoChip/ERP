# ERP

#OS.

sudo mkdir /mnt/usb
fdisk -l
sudo mount /dev/sda /mnt/usb
sudo dd if=img of=d/dev/mmcblk1
sudo umount /mnt/usb
sudo reboot

#mDNS
sudo hostname erp
sudo apt-get -y install avahi-daemon
sudo update-rc.d avahi-daemon defaults
rm -fr ERP && git clone https://github.com/OoChip/ERP.git && sudo mv ERP/services/* /etc/avahi/services/ && rm -fr ERP
sudo /etc/init.d/avahi-daemon restart
sudo systemctl restart avahi-daemon

#Docker.

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \ ca-certificates \ curl \ gnupg \ lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Docker sin SUDO.

sudo groupadd docker
sudo usermod -aG docker oochip

#Portainer.

docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainerce:latest

docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /:/host portainer/agent:2.10.0

#user: "oochip" password: "7Abrete37."

#Stack.

1. https://github.com/OoChip/ERP/
2. refs/heads/main
3. compose-amd64.yml or compose-arm64v8.yml

#mkcert
sudo apt install libnss3-tools

# https://dl.filippo.io/mkcert/v1.4.4?for=linux/arm64
# https://dl.filippo.io/mkcert/latest?for=linux/amd64
# https://dl.filippo.io/mkcert/v1.4.4?for=windows/amd64

sudo curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/arm64"
sudo chmod +x mkcert*
sudo mv mkcert* /usr/local/bin/mkcert
sudo mkcert -install

sudo mkcert -key-file key.pem -cert-file cert.pem localhost 127.0.0.1 0.0.0.0 erp.local "*.erp.local"

#NPM
#  Default login. 
#   Email: admin@example.com
#   Password: changeme



