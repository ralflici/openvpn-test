#!/bin/bash

CERT=$(dirname $0)/clientcert.pem
KEY=$(dirname $0)/clientkey.pem
PROTO=${PROTO:-udp}

FP=$(openssl x509 -in $(dirname $0)/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-client ${OVPN} --dev tun --client --remote 10.10.10.1 \
    --proto ${PROTO} \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 4 $@
