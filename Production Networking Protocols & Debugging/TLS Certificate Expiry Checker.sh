#!/bin/bash

# First argument is hostname:port (e.g., google.com:443)
input=$1

# Split into hostname and port
hostname=$(echo $input | cut -d':' -f1)
port=$(echo $input | cut -d':' -f2)

# If no port given, use 443 as default
if [ -z "$port" ]; then
    port=443
fi

echo "Checking $hostname on port $port..."

# Get certificate expiry date
# openssl s_client connects, then we extract the "notAfter" date
expiry_date=$(echo | openssl s_client -servername $hostname -connect $hostname:$port 2>/dev/null | openssl x509 -noout -enddate | cut -d'=' -f2)

# If empty, connection failed
if [ -z "$expiry_date" ]; then
    echo "ERROR: Could not connect to $hostname:$port"
    exit 1
fi

# Convert expiry date to seconds since 1970 (Unix time)
expiry_seconds=$(date -d "$expiry_date" +%s)
now_seconds=$(date +%s)

# Calculate days remaining (86400 seconds in a day)
days_remaining=$(( ($expiry_seconds - $now_seconds) / 86400 ))

echo "Certificate expires on: $expiry_date"
echo "Days remaining: $days_remaining"

# Alert based on days remaining
if [ $days_remaining -lt 30 ]; then
    echo "STATUS: CRITICAL - Less than 30 days left!"
elif [ $days_remaining -lt 90 ]; then
    echo "STATUS: WARNING - Less than 90 days left!"
else
    echo "STATUS: OK"
fi