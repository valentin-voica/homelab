#!/bin/bash

# Prompt the user for the string to find
read -p "Enter the string you want to find in file and directory names (or press Enter for all): " search_string

# Initialize counters
file_count=0
directory_count=0

# Find all files with the specified string or all files if blank
if [[ -z "$search_string" ]]; then
    echo "All files:"
    while IFS= read -r file; do
        echo "$file"
        ((file_count++))
    done < <(find . -type f)  # No filter if search_string is empty
else
    echo "Files containing '$search_string':"
    while IFS= read -r file; do
        echo "$file"
        ((file_count++))
    done < <(find . -type f -name "*$search_string*")
fi

# Find all directories with the specified string or all directories if blank
if [[ -z "$search_string" ]]; then
    echo ""
    echo "All directories:"
    while IFS= read -r dir; do
        echo "$dir"
        ((directory_count++))
    done < <(find . -type d)  # No filter if search_string is empty
else
    echo ""
    echo "Directories containing '$search_string':"
    while IFS= read -r dir; do
        echo "$dir"
        ((directory_count++))
    done < <(find . -type d -name "*$search_string*")
fi

# Summary
echo ""
echo "Summary:"
echo "Total files found: $file_count"
echo "Total directories found: $directory_count"
