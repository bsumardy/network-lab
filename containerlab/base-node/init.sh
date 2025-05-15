#!/bin/bash

# Start SSH service
service ssh start

# Start FRR daemons
service frr start

# Keep container alive
tail -f /dev/null
