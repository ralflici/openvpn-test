#!/bin/bash

OVPN=/home/ordex/exp/openvpn_dev/openvpn/src/openvpn/openvpn

CA=/home/ordex/exp/test-pki/pki/ca.crt
DH=/home/ordex/exp/test-pki/pki/dh/pem
CERT=/home/ordex/exp/test-pki/pki/issued/client1.crt
KEY=/home/ordex/exp/test-pki/pki/private/client1.key

ip netns exec ovpn-client ${OVPN} --dev tun --tls-client --remote 10.10.10.1 \
	--ifconfig 10.10.0.2 10.10.0.1 \
	--cipher AES-256-GCM \
	--ca ${CA} \
	--cert ${CERT} --key ${KEY} --verb 3 $@
