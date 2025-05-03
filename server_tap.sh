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

CERT=servercert.pem
KEY=serverkey.pem
PROTO=${PROTO:-udp}

FP=$(openssl x509 -in $(dirname $0)/clientcert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

(sleep 3 && ip -n ovpn-server addr add 10.10.0.1/24 dev tap0 && ip -n ovpn-server link set dev tap0 up) &
ip netns exec ovpn-server ${VALGRIND} ${OVPN} \
	--mode server \
	--tls-server \
	--dev tap \
    --proto ${PROTO} \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} \
	--verb 4 --dh none $@
