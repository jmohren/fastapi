server_domain_or_IP=curl ipinfo.io/ip

cd
sed -i 's/server_name.*;/server_name $server_domain_or_IP;/' /etc/nginx/sites-enabled/api

sudo nano /etc/nginx/sites-enabled/api

python3 main.py