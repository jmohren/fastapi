server_domain_or_IP=curl ipinfo.io/ip

cd
sudo sed -i 's/server_name.*;/server_name $server_domain_or_IP;/' /etc/nginx/sites-enabled/api

cd
python3 apiv/main.py