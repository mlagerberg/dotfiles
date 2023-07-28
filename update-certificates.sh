#!/bin/bash

#certbot renew --tls-sni-01-port=8888
certbot renew --preferred-challenges http --http-01-port=8888
source /home/vps/dotfiles/dotfiles/combine-certificates.sh
#service haproxy reload
systemctl reload haproxy
