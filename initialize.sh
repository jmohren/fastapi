sudo apt update
sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl
sudo -H pip3 install --upgrade pip

cd api

#Create env & install requirements
virtualenv env
source env/bin/activate
pip install -r requirements.txt

#Create gunicorn.socket file
cat > /etc/systemd/system/gunicorn.socket << ENDOFFILE
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
ENDOFFILE

#Create gunicorn.service file
cat > /etc/systemd/system/gunicorn.service << ENDOFFILE
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/api
ExecStart=/home/ubuntu/api/env/bin/gunicorn \
          --access-logfile - \
          --workers 5 \
          --bind unix:/run/gunicorn.sock \
          --worker-class uvicorn.workers.UvicornWorker \
          app:app

[Install]
WantedBy=multi-user.target
ENDOFFILE

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

#Create api file
cat > /etc/nginx/sites-enabled/api << ENDOFFILE
server {
    listen 80;
    listen 443 ssl;
    ssl on;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    server_name server_domain_or_IP;
    location / {
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
ENDOFFILE

sudo systemctl daemon-reload
sudo systemctl restart gunicorn
sudo systemctl restart nginx