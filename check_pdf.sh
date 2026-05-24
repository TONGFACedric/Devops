#!/bin/bash
for file in /home/*.pdf; do
    if [ -f "$file" ]; then
        echo "Found PDF: $(basename "$file") (Size: $(stat -c %s "$file"))"
    fi
done


