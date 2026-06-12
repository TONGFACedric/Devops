#!/bin/bash

echo "DOMAIN | IP | TTL | STATUS"
echo "----------------------------------------"

# Read the file line by line
while read domain; do
    # Use dig to get the A record, ask for +short output
    # We'll get IP and TTL separately
    
    # Get IP address (first A record)
    ip=$(dig +short A $domain | head -1)
    
    # Get TTL (use dig +noall +answer, then extract the number)
    ttl=$(dig +noall +answer A $domain | awk '{print $2}')
    
    # If TTL is empty (error), skip
    if [ -z "$ttl" ]; then
        echo "$domain | ERROR | ERROR | FAILED"
        continue
    fi
    
    # Check if TTL > 3600
    if [ $ttl -gt 3600 ]; then
        status="HIGH-TTL"
    else
        status="OK"
    fi
    
    # Print the result
    echo "$domain | $ip | $ttl | $status"
    
done < domains.txt