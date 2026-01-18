#!/bin/bash

# Get the current directory
DIR=$(pwd)

# Initialize a counter for renamed files
renamed_count=0

# Function to rename files in a given directory
rename_files() {
  local current_dir="$1"

  # Iterate through each file and subdirectory in the current directory
  for item in "$current_dir"/*; do
    # If it's a directory, call the function recursively
    if [ -d "$item" ]; then
      # Create a new name for the directory by replacing spaces with underscores
      local new_dir="${item// /_}"
      if [ "$item" != "$new_dir" ]; then
        mv "$item" "$new_dir"  # Rename directory first
        echo "Renamed Directory: $(basename "$item") -> $(basename "$new_dir")"
        ((renamed_count++))  # Increment the counter for renamed directories
      fi
      rename_files "$new_dir"  # Process the renamed directory
    elif [ -f "$item" ]; then
      # Create the new filename by replacing spaces with underscores
      local new_file="${item// /_}"

      # Rename the file only if the new filename is different
      if [ "$item" != "$new_file" ]; then
        mv "$item" "$new_file"
        echo "Renamed File: $(basename "$item") -> $(basename "$new_file")"
        ((renamed_count++))  # Increment the counter
      fi
    fi
  done
}

# Call the function on the current directory
rename_files "$DIR"

# Print the summary
echo "Summary: Renamed $renamed_count item(s)."

