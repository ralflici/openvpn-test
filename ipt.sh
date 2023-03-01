#!/bin/bash

nft add table filter
nft flush table filter
nft 'add chain filter input { type filter hook input priority 0 ; }'
nft add rule filter input udp dport 1194 limit rate 1/minute accept
nft add rule filter input udp dport 1194 drop
