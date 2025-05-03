#!/bin/bash

CERT="$(dirname $0)/clientcert.pem"
KEY="$(dirname $0)/clientkey.pem"
PROTO=${PROTO:-udp}

FP=$(openssl x509 -in $(dirname $0)/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

(sleep 3 && ip -n ovpn-client addr add 10.10.0.2/24 dev tap0 && ip -n ovpn-client link set dev tap0 up) &

ip netns exec ovpn-client ${OVPN} --dev tap --client --remote 10.10.10.1 \
    --proto ${PROTO} \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 4 $@

