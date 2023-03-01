#!/bin/bash

OVPN=/home/ordex/exp/openvpn/src/openvpn/openvpn

ip netns exec ovpn-client ${OVPN} --dev tun --remote 10.10.10.1 \
	--secret shared.key \
	--ifconfig 10.10.0.2 10.10.0.1 \
	--data-ciphers-fallback AES-128-CBC \
	--verb 3 $@
