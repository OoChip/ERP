# ERP

#OS.

sudo mkdir /mnt/usb
fdisk -l
sudo mount /dev/sda /mnt/usb
sudo dd if=img of=d/dev/mmcblk1
sudo umount /mnt/usb

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
