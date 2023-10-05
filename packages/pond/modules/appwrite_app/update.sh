#!/bin/bash

# Check if a directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Ensure the provided directory exists
DIR="$1"
if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist."
    exit 1
fi

# Rename files containing the word "firebase" to replace it with "appwrite"
find "$DIR" -type f -name '*firebase*' | while read -r file; do
    newname="$(echo "$file" | sed 's/firebase/appwrite/g')"
    mv "$file" "$newname"
    echo "Renamed $file to $newname"
done

echo "Done."
