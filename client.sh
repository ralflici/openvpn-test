#!/bin/bash

#VALGRIND="valgrind --leak-check=full --show-leak-kinds=all"
#GDB="gdb --args"

OVPN=/home/ordex/exp/openvpn_dev/openvpn/src/openvpn/openvpn
#OVPN=/home/ordex/exp/openvpn-master
CERT=$(dirname $0)/clientcert.pem
KEY=$(dirname $0)/clientkey.pem

FP=$(openssl x509 -in $(dirname $0)/servercert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-client ${GDB} ${VALGRIND} ${OVPN} \
	--dev tun --client --remote 10.10.10.1 \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} --verb 3 $@
