#!/bin/bash

CA=${CA:-${PKI_DIR}/pki/ca.crt}
CERT=${CERT:-${PKI_DIR}/pki/issued/client.crt}
KEY=${KEY:-${PKI_DIR}/pki/private/client.key}
PROTO=${PROTO:-udp}

ip -n ovpn-client addr add 10.10.30.1/24 dev lo
ip -n ovpn-client addr add 10.10.40.1/24 dev lo
ip -6 -n ovpn-client addr add 2001:db8:10:30::1/64 dev lo
ip -6 -n ovpn-client addr add 2001:db8:10:40::1/64 dev lo
ip -n ovpn-client link set dev lo up

ip netns exec ovpn-client \
	${OVPN} --dev tun1 --client \
	--remote 10.10.10.1 \
    --proto ${PROTO} \
	--ca ${CA} \
	--cert ${CERT} \
	--key ${KEY} \
	--verb 4 $@
