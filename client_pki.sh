#!/bin/bash

CA=${CA:-${PKI_DIR}/pki/ca.crt}
CERT=${CERT:-${PKI_DIR}/pki/issued/client.crt}
KEY=${KEY:-${PKI_DIR}/pki/private/client.key}
PROTO=${PROTO:-udp}

ip netns exec ovpn-client \
	${OVPN} --dev tun --client \
	--remote  10.10.10.1 \
    --proto ${PROTO} \
	--ca ${CA} \
	--cert ${CERT} \
	--key ${KEY} \
	--verb 4 $@
