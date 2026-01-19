#!/bin/bash

# Counters for files and directories renamed
file_count=0
dir_count=0

# Function to replace spaces with underscores
replace_spaces() {
    for item in "$1"/*; do
        # Check if the item is a directory
        if [[ -d "$item" ]]; then
            new_name="$(echo "$item" | sed 's/ /_/g')"
            if [[ "$item" != "$new_name" ]]; then
                mv -v "$item" "$new_name"  # Rename the directory
                ((dir_count++))  # Increment directory counter
            fi
            # Recur into the renamed directory
            replace_spaces "$new_name"
        fi
        
        # Check if the item is a file
        if [[ -f "$item" ]]; then
            new_name="$(echo "$item" | sed 's/ /_/g')"
            if [[ "$item" != "$new_name" ]]; then
                mv -v "$item" "$new_name"  # Rename the file
                ((file_count++))  # Increment file counter
            fi
        fi
    done
}

# Start the script from the current directory
replace_spaces "."

# Summary of renamed items
echo "Renaming complete."
echo "Total files renamed: $file_count"
echo "Total directories renamed: $dir_count"
