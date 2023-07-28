#!/bin/bash

# Combines multiple fullchain.pem and privkey.pem combo's
# into single files, so HAProxy can use them

for CERT in `find /etc/letsencrypt/live/* -type d`; do
        CERT=`basename $CERT`
        # Combine fullchain and privkey into one
        cat /etc/letsencrypt/live/$CERT/fullchain.pem /etc/letsencrypt/live/$CERT/privkey.pem > /etc/ssl/$CERT.pem
done
