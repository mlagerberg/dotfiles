#!/bin/bash

echo "Usage: ./request_certificate domain.com"
echo "1. Run as root"
echo "2. Choose option 1 below"
echo "3. Run ./combine-certificates"
echo "4. Add certificate in /etc/haproxy/haproxy.cfg"
echo "5. Reload HAProxy (systemctl reload haproxy)"

certbot certonly --preferred-challenges http --http-01-port=8888 -d $1
