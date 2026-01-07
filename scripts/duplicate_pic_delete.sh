#!/bin/bash

find . -type f -name "*.jpg" -print0 | while IFS= read -r -d '' file; do
  heic_file="${file%.jpg}.heic"
  if [ -f "$heic_file" ]; then
    rm "$file"
    echo "Deleted $file"
  fi
done
