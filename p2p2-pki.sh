#!/bin/bash

CA=${CA:-${PKI_DIR}/pki/ca.crt}
DH=${DH:-${PKI_DIR}/pki/dh/pem}
CERT=${CERT:-${PKI_DIR}/pki/issued/client1.crt}
KEY=${KEY:-${PKI_DIR}/pki/private/client1.key}

ip netns exec ovpn-client ${OVPN} --dev tun --tls-client --remote 10.10.10.1 \
	--ifconfig 10.10.0.2 10.10.0.1 \
	--cipher AES-256-GCM \
	--ca ${CA} \
	--cert ${CERT} --key ${KEY} --verb 4 $@
