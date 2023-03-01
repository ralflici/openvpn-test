#!/bin/bash

OVPN=/home/ordex/exp/openvpn_dev/openvpn/src/openvpn/openvpn
CERT=$(dirname $0)/clientcert.pem
KEY=$(dirname $0)/clientkey.pem

FP=$(openssl x509 -in $(dirname $0)/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-client ${OVPN} --dev tun --client --remote 10.10.10.1 \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 3 $@
