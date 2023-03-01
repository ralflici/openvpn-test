#!/bin/bash

OVPN=/home/ordex/exp/openvpn/src/openvpn/openvpn
CERT=/home/ordex/exp/openvpn-test/clientcert.pem
KEY=/home/ordex/exp/openvpn-test/clientkey.pem

FP=$(openssl x509 -in /home/ordex/exp/openvpn-test/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-client ${OVPN} --dev tap --client --remote 10.10.10.1 \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 3 $@

ip -n ovpn-client addr add 10.10.8.2/24 dev tap0
