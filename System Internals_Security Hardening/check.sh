#!/bin/bash
if ! systemctl is-active --quiet cron; then
    systemctl start cron
    echo "$(date) — restarted cron" >> ./var/log/monitor.log
fi