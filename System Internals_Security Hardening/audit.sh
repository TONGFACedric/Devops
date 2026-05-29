#!/bin/bash
echo "$(date)" >> /var/log/suid_audit.log
find / -perm -4000 2>/dev/null >> /var/log/suid_audit.log   # SUID
find / -perm -2000 2>/dev/null >> /var/log/suid_audit.log   # SGID

# Warn about weird locations
find / -perm -4000 2>/dev/null | grep -v "^/usr/bin" | grep -v "^/bin" >> ./var/log/suid_audit.log