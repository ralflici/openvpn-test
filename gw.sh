nft add table nat
nft flush table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'

nft add rule nat postrouting ip saddr 192.168.1.0/24 oif tun0 masquerade
