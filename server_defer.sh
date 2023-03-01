#!/bin/bash

#VALGRIND=valgrind

ip netns add ovpn-server
ip netns add ovpn-client

modprobe veth
ip link add veth0 type veth peer veth1
ip link set veth0 netns ovpn-server
ip link set veth1 netns ovpn-client
ip -n ovpn-server addr add 10.10.10.1/24 dev veth0
ip -n ovpn-client addr add 10.10.10.2/24 dev veth1
ip -n ovpn-server link set veth0 up
ip -n ovpn-client link set veth1 up

OVPN=${OVPN:-/home/ordex/exp/openvpn_dev/openvpn/src/openvpn/openvpn}
CERT=$(dirname $0)/servercert.pem
KEY=$(dirname $0)/serverkey.pem

CLI_CERT=$(dirname $0)/clientcert.pem

FP=$(openssl x509 -in ${CLI_CERT} -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-server ${VALGRIND} ${OVPN} \
	--server 10.10.0.0 255.255.255.0 \
	--dev tun \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} \
	--verb 4 --dh none $@
