#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Find all pubspec.yaml files in the monorepo and update the ref value
# only if the previous line contains the specified URL.
find . -name 'pubspec.yaml' | while read -r file; do
    sed -E -e "/url: git@github\.com:jaboyc\/jlogical_utils\.git/!b" -e "n;s/(ref: \")([^\"]+)(\")/\1$CURRENT_BRANCH\3/" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

echo "Updated all relevant pubspec.yaml files with ref: $CURRENT_BRANCH"
