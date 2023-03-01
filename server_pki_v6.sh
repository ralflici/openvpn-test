#!/bin/bash

#GDB="gdb --args"
#VALGRIND=valgrind

ip netns del ovpn-server
ip netns del ovpn-client

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
#OVPN=${OVPN:-/home/ordex/exp/openvpn-master}

CA=../../test-pki/pki/ca.crt
DH=../../test-pki/pki/dh.pem
CERT=../../test-pki/pki/issued/server.crt
KEY=../../test-pki/pki/private/server.key

#ip netns exec ovpn-server \
	${GDB} ${VALGRIND} ${OVPN} \
	--server 10.10.0.0 255.255.255.0 \
	--proto udp6 \
	--dev tun \
	--topology subnet \
	--ca ${CA} \
	--cert ${CERT} --key ${KEY} \
	--verb 3 --dh ${DH} $@
