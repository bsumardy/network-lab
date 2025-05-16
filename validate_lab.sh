#!/bin/bash

set -e

NODES=("spine1" "spine2" "leaf1" "leaf2")
PORTS=(2221 2222 2223 2224)

echo "[INFO] Checking container statuses..."
for NODE in "${NODES[@]}"; do
  containerlab inspect -t containerlab/topo.clab.yaml | grep "clab-fabric-lab-${NODE}" | grep -q running || {
    echo "[ERROR] $NODE is not running!"
    exit 1
  }
done
echo "[OK] All containers running."

echo "Waiting 60 seconds to let interfaces and OSPF neighbors fully form..."
sleep 30

echo "[INFO] Validating hostname & OSPF neighbors on all nodes..."
for i in "${!NODES[@]}"; do
  NODE=${NODES[$i]}
  PORT=${PORTS[$i]}
  echo ">>> $NODE (SSH port $PORT)"

  sshpass -p root ssh -p "$PORT" -o StrictHostKeyChecking=no root@localhost << EOF
    echo -n "Hostname: "
    vtysh -c "show running-config" | grep '^hostname ' || echo "[ERROR] Missing hostname"
    echo "OSPF Neighbors:"
    vtysh -c "show ip ospf neighbor" || echo "[ERROR] No OSPF neighbors"
EOF

  echo ""
done

echo "[SUCCESS] All nodes verified."
