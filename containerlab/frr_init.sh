#!/bin/bash

set -e

# Wait for eth1 and eth2 to be present
echo "[INFO] Waiting for interfaces eth1 and eth2..."
for i in {1..10}; do
  ip link show eth1 &> /dev/null && ip link show eth2 &> /dev/null && break
  sleep 1
done

# Assign IP addresses
echo "[INFO] Assigning IP addresses..."
ip addr add 10.0.0.1/30 dev eth1 || true
ip addr add 10.0.0.5/30 dev eth2 || true

# Start zebra and ospfd daemons (only if not already running)
echo "[INFO] Starting FRR daemons..."
pgrep -x zebra &> /dev/null || /usr/lib/frr/zebra -d
pgrep -x ospfd &> /dev/null || /usr/lib/frr/ospfd -d

sleep 2  # give daemons time to initialize

# Inject FRR config via vtysh
echo "[INFO] Injecting OSPF config into vtysh..."
vtysh << EOF
conf t
hostname spine1
no ipv6 forwarding
service integrated-vtysh-config
!
interface eth1
 ip address 10.0.0.1/30
 ip ospf area 0
exit
!
interface eth2
 ip address 10.0.0.5/30
 ip ospf area 0
exit
!
router ospf
 ospf router-id 172.20.20.1
 network 10.0.0.0/30 area 0
 network 10.0.0.4/30 area 0
exit
end
write
EOF

echo "[INFO] FRR OSPF config applied successfully."
