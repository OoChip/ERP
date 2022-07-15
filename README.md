# ERP
#OS.
sudo mkdir /mnt/usb
fdisk -l
sudo mount /dev/sda /mnt/usb
sudo dd if=img of=d/dev/mmcblk1
sudo umount /mnt/usb
sudo reboot

#Usermod
#login: rock  passwd: rock
passwd
sudo passwd root
sudo reboot
#login as root
usermod -l rock oochip
usermod -d /home/oochip oochip
groupmod -n oochip rock

#Continue in ssh
sudo apt update && sudo apt install -y curl
sudo curl -fsSL https://raw.githubusercontent.com/OoChip/ERP/main/install.sh -o install.sh
sudo sh install.sh

#Portainer
# http://erp.local:82
# Set login to:
#   User: "oochip2001@gmail.com"
#   Password: 7Abrete37  (7Abrete3712345)

#Stack.
1. https://github.com/OoChip/ERP/
2. refs/heads/main
3. compose-amd64.yml or compose-arm64v8.yml

#NPM
# http://erp.local:81
# Default login. 
#   Email: admin@example.com
#   Password: changeme
# Change to 
#   Email: oochip2001@gmail.com
#   Password: 7Abrete37

##########################################################################################################################
##########################################################################################################################

#mkcert
sudo apt install libnss3-tools

sudo curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/arm64"
sudo curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"

sudo chmod +x mkcert*
sudo mv mkcert* /usr/local/bin/mkcert
sudo mkcert -key-file key.pem -cert-file cert.pem localhost 127.0.0.1 0.0.0.0 erp.local
sudo mkcert -install
sudo rm *.pem

#Github
sudo apt install git
git config --global user.name "oochip"
git config --global user.email "oochip2001@gmail.com"
ssh-keygen -t ed25519 -C "oochip2001@gmail.com"
ssh-add ~/.ssh/id_ed25519
sudo apt-get install -y xclip
xclip -sel clip < ~/.ssh/id_ed25519.pub
#In Github -> settings -> SSH and GPG keys -> Add SSH key -> paste

#Clone repo
mkdir -p $HOME/src
cd ~/src
git clone git@github.com:odoo/odoo.git

#Install Dependencies
sudo apt install -y python3-pip python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libssl-dev libpq-dev libjpeg-dev

#Virtualenv
sudo apt-get install -y python3-virtualenv virtualenv
virtualenv venv # venv = name od the virtual enviroment tu be created.
venv/bin/activate

Install Requirements (install inside of the venv)
pip3 install -r ~/src/odoo/requirements.txt
cd /tmp/
sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb
sudo gdebi --n wkhtmltox_0.12.5-1.focal_amd64.deb
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin

#Install and config Postgresql
sudo apt install -y postgresql postgresql-client
sudo -u postgres createuser -s $USER
createdb odoo

#Run
cd $HOME/src/odoo/
./odoo-bin --addons-path="addons" -d odoo
./odoo-bin -c odoo.conf

login:
http://localhost:8069
http://0.0.0.0:8069
http://127.0.0.1:8069

email = admin
password = admin

#Scaffold
sudo mkdir ~/src/odoo/custom/
odoo-bin scaffold my_module /custom/

