#!/bin/bash
DIR="./var/log"
if [ -d "$DIR" ]; then
    echo "The file exists. Compressing..."
          tar -czf /backup/logs_$(date +%F).tar.gz /var/log
else
    echo "No file found."
fi