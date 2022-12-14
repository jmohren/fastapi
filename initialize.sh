#export NEEDRESTART_MODE=a
#export DEBIAN_FRONTEND=noninteractive
#Does not work!!!!

sudo apt -y update
sudo apt -y install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl

#For debugging
sudo cp api/git-init.sh ../

#SSL certificate
sudo apt-get -y install openssl
sudo mkdir /etc/nginx/ssl
sudo openssl req -batch -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/server.key \
-out /etc/nginx/ssl/server.crt

#Create env & install requirements
sudo apt-get -y install python3-virtualenv
virtualenv env
source env/bin/activate
pip install -r requirements.txt

#Move gunicorn.socket file
sudo cp files/gunicorn.socket /etc/systemd/system/

#Move gunicorn.service file
sudo cp files/gunicorn.service /etc/systemd/system/

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

#Move api file
sudo cp files/api /etc/nginx/sites-enabled/

sudo systemctl daemon-reload
sudo systemctl restart gunicorn
sudo systemctl restart nginx

./start.sh