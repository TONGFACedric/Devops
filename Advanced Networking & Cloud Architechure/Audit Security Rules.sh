#!/bin/bash


# Read the rules file (first argument when running script)
RULES_FILE="$1"

# Check if file exists - if not, yell and exit
if [ ! -f "$RULES_FILE" ]; then
    echo "❌ ERROR: File '$RULES_FILE' not found!"
    echo "Usage: ./audit_security_rules.sh rules.txt"
    exit 1
fi

# Initialize flags - assume everything is safe
SSH_VIOLATION=0      # 0 = safe, 1 = violation found
MYSQL_VIOLATION=0    # 0 = safe, 1 = violation found

echo "STARTING SECURITY AUDIT..."
echo "====================================="

# Read each line from the rules file
while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Split the line into variables
    DIRECTION=$(echo "$line" | awk '{print $1}')
    PORT=$(echo "$line" | awk '{print $2}')
    CIDR=$(echo "$line" | awk '{print $3}')
    ACTION=$(echo "$line" | awk '{print $4}')
    
    # Convert to uppercase for comparison
    DIRECTION=$(echo "$DIRECTION" | tr '[:lower:]' '[:upper:]')
    ACTION=$(echo "$ACTION" | tr '[:lower:]' '[:upper:]')
    
    # Check if this is a dangerous rule
    if [ "$PORT" = "22" ] && [ "$CIDR" = "0.0.0.0/0" ] && [ "$ACTION" = "ALLOW" ]; then
        SSH_VIOLATION=1
        echo "SSH VIOLATION: $line"
        echo "   → Everyone on internet can SSH! (That's BAD!)"
    fi
    
    if [ "$PORT" = "3306" ] && [ "$CIDR" = "0.0.0.0/0" ] && [ "$ACTION" = "ALLOW" ]; then
        MYSQL_VIOLATION=1
        echo "MYSQL VIOLATION: $line"
        echo "   → Everyone on internet can access MySQL! (That's BAD!)"
    fi
    
done < "$RULES_FILE"

echo "====================================="
echo "AUDIT RESULTS:"

# Print results
if [ "$SSH_VIOLATION" -eq 0 ]; then
    echo "SSH CHECK: PASS - No public SSH access found"
else
    echo "SSH CHECK: FAIL - Public SSH access detected!"
fi

if [ "$MYSQL_VIOLATION" -eq 0 ]; then
    echo "MYSQL CHECK: PASS - No public MySQL access found"
else
    echo "MYSQL CHECK: FAIL - Public MySQL access detected!"
fi

echo "====================================="