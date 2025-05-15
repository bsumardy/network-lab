#!/bin/bash

echo "🔍 Checking for running containerlab containers..."
containers=$(docker ps -a --filter name=clab- -q)

if [ -n "$containers" ]; then
    echo "🗑 Removing containerlab containers..."
    docker rm -f $containers
else
    echo "✅ No clab-* containers to remove."
fi

echo "🔍 Checking for containerlab networks..."
networks=$(docker network ls --filter name=clab --format "{{.Name}}")

if [ -n "$networks" ]; then
    echo "🧹 Removing containerlab networks..."
    for net in $networks; do
        docker network rm "$net"
    done
else
    echo "✅ No containerlab networks to remove."
fi

# Free ports check (2222–2225 range)
echo "🔎 Checking if any common clab ports are still in use..."
for port in 2222 2223 2224 2225; do
    pid=$(lsof -t -i:$port)
    if [ -n "$pid" ]; then
        echo "⚠️ Port $port is still in use by PID $pid. You can kill it with:"
        echo "    sudo kill -9 $pid"
    else
        echo "✅ Port $port is free."
    fi
done

ssh-keygen -f ~/.ssh/known_hosts -R '[127.0.0.1]:2221'
ssh-keygen -f ~/.ssh/known_hosts -R '[127.0.0.1]:2222'
ssh-keygen -f ~/.ssh/known_hosts -R '[127.0.0.1]:2223'
ssh-keygen -f ~/.ssh/known_hosts -R '[127.0.0.1]:2224'

echo "🧼 Cleanup complete."
