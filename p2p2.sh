#!/bin/bash

CERT=$(pwd)/clientcert.pem
KEY=$(pwd)/clientkey.pem

FP=$(openssl x509 -in $(pwd)/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-client ${OVPN} --dev tun --tls-client --remote 10.10.10.1 \
	--ifconfig 10.10.0.2 10.10.0.1 \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 4 $@
