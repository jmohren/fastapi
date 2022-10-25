server_domain_or_IP="$(curl ipinfo.io/ip)"

sudo sed -i "s/server_name.*;/server_name $server_domain_or_IP;/" /etc/nginx/sites-enabled/api

sudo service nginx restart

source env/bin/activate
python3 main.py