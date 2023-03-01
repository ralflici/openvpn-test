#!/bin/bash

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

ip netns exec ovpn-server ${OVPN} \
	--secret shared.key \
	--ifconfig 10.10.0.1 10.10.0.2 \
	--dev tun \
	--data-ciphers-fallback AES-128-CBC \
	--verb 4 $@
