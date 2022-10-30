sudo apt update
sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl
sudo -H pip3 install --upgrade pip

#Create env & install requirements
pip install virtualenv
virtualenv env
source env/bin/activate
pip install -r requirements.txt

#Move gunicorn.socket file
sudo mv files/gunicorn.socket /etc/systemd/system/

#Move gunicorn.service file
sudo mv files/gunicorn.service /etc/systemd/system/

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

#Move api file
sudo mv files/api /etc/nginx/sites-enabled/

sudo systemctl daemon-reload
sudo systemctl restart gunicorn
sudo systemctl restart nginx

./start.sh