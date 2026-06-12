#!/bin/bash

# Run this for 60 seconds, checking every 10 seconds → 6 times
for i in {1..6}; do
    # Get counts for each socket state
    established=$(ss -nat | grep ESTAB | wc -l)
    timewait=$(ss -nat | grep TIME-WAIT | wc -l)
    listen=$(ss -nat | grep LISTEN | wc -l)
    
    # Print summary
    echo "=== Check $i at $(date) ==="
    echo "ESTABLISHED: $established"
    echo "TIME_WAIT: $timewait"
    echo "LISTEN: $listen"
    echo ""
    
    # If TIME_WAIT > 50, write to log
    if [ $timewait -gt 50 ]; then
        echo "$(date) - WARNING: TIME_WAIT count is $timewait" >> /tmp/socket_monitor.log
    fi
    
    # Wait 10 seconds before next check (but not after last)
    if [ $i -lt 6 ]; then
        sleep 10
    fi
done