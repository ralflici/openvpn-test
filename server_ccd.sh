#!/bin/bash

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

# Set up namespaces
ip netns del ovpn-server 2>/dev/null
ip netns del ovpn-client 2>/dev/null
ip netns add ovpn-server
ip netns add ovpn-client

ip netns exec ovpn-server sysctl -w net.ipv4.ip_forward=1
ip netns exec ovpn-server sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ovpn-client sysctl -w net.ipv4.ip_forward=1
ip netns exec ovpn-client sysctl -w net.ipv6.conf.all.forwarding=1

# veth interface between server and client
ip link add veth0 type veth peer name veth1
ip link set veth0 netns ovpn-server
ip link set veth1 netns ovpn-client
ip -n ovpn-server addr add 10.10.10.1/24 dev veth0
ip -n ovpn-client addr add 10.10.10.2/24 dev veth1
ip -n ovpn-server link set veth0 up
ip -n ovpn-client link set veth1 up

# Define OpenVPN paths and certificates
CA=${CA:-${PKI_DIR}/pki/ca.crt}
DH=${DH:-${PKI_DIR}/pki/dh.pem}
CERT=${CERT:-${PKI_DIR}/pki/issued/server.crt}
KEY=${KEY:-${PKI_DIR}/pki/private/server.key}
PROTO=${PROTO:-udp}

# Start the OpenVPN server in the foreground
ip netns exec ovpn-server \
    ${OVPN} \
    --client-config-dir ccd \
    --server 10.10.0.0 255.255.255.0 \
    --dev tun \
    --proto ${PROTO} \
    --topology subnet \
    --push "redirect-gateway def1" \
    --keepalive 20 60 \
    --route 10.10.30.0 255.255.255.0 \
    --route 10.10.40.0 255.255.255.0 \
    --route-ipv6 2001:db8:10:30::/64 \
    --route-ipv6 2001:db8:10:40::/64 \
    --ca ${CA} \
    --cert ${CERT} --key ${KEY} \
    --verb 4 --dh ${DH} $@
