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

OVPN=${OVPN:-/home/ordex/exp/openvpn/src/openvpn/openvpn}
CERT=/home/ordex/exp/openvpn-test/servercert.pem
KEY=/home/ordex/exp/openvpn-test/serverkey.pem

FP=$(openssl x509 -in /home/ordex/exp/openvpn-test/clientcert.pem -noout -fingerprint -sha256 | sed 's/.*=//')

ip netns exec ovpn-server ${VALGRIND} ${OVPN} \
	--mode server \
	--tls-server \
	--dev tap \
	--cipher AES-256-GCM \
	--peer-fingerprint ${FP} \
	--cert ${CERT} --key ${KEY} \
	--verb 3 --dh none $@

ip -n ovpn-server addr add 10.10.8.1/24 dev tap0
