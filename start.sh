server_domain_or_IP="$(curl ipinfo.io/ip)"

cd
sudo sed -i 's/server_name.*;/server_name $server_domain_or_IP;/' /etc/nginx/sites-enabled/api

cd home/ubuntu/apiv/
python3 main.py