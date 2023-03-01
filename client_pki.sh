#!/bin/bash

OVPN=${OVPN:-/home/ordex/exp/openvpn_dev/openvpn/src/openvpn/openvpn}
#OVPN=${OVPN:-/home/ordex/exp/openvpn-master}

CA=../../test-pki/pki/ca.crt
CERT=${CERT:-../../test-pki/pki/issued/client1.crt}
KEY=${KEY:-../../test-pki/pki/private/client1.key}

ip netns exec ovpn-client \
	${OVPN} --dev tun --client \
	--remote  10.10.10.1 \
	--ca ${CA} \
	--cert ${CERT} \
	--key ${KEY} \
	--verb 3 $@
