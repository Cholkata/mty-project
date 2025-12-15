#!/bin/bash
SEARCH_DIR="/var/www/html"
echo "Searching for broken symbolic links in $SEARCH_DIR"
BROKEN_LINKS=$(find "$SEARCH_DIR" -xtype l)
if [ -z "$BROKEN_LINKS" ]; then
    echo "No broken symbolic links found."
else
    echo "Broken symbolic links found:"
    echo "$BROKEN_LINKS"
fi