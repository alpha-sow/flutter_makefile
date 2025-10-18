#!/bin/bash

# update_version.sh - Updates pubspec.yaml with semantic version and incremented build number
# Usage: ./update_version.sh <new_semantic_version>
# Example: ./update_version.sh 1.2.6

set -e

NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
    echo "Error: No version provided"
    echo "Usage: $0 <new_semantic_version>"
    exit 1
fi

PUBSPEC_FILE="pubspec.yaml"
README_FILE="README.md"

# Extract current build number
CURRENT_BUILD=$(grep -E '^version: ' "$PUBSPEC_FILE" | sed -E 's/.*\+([0-9]+)/\1/')

if [ -z "$CURRENT_BUILD" ]; then
    echo "Error: Could not extract build number from $PUBSPEC_FILE"
    exit 1
fi

# Increment build number
NEW_BUILD=$((CURRENT_BUILD + 1))

# Update pubspec.yaml with new version and incremented build number
FULL_VERSION="${NEW_VERSION}+${NEW_BUILD}"

echo "Updating $PUBSPEC_FILE to version $FULL_VERSION"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires empty string for -i flag
    sed -i '' "s/^version: .*/version: $FULL_VERSION/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: .*/version: $FULL_VERSION/" "$PUBSPEC_FILE"
fi

echo "Updating $README_FILE..."

# Update README.md - version badge
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires empty string for -i flag
    sed -i '' "s/version-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*-blue/version-$NEW_VERSION-blue/" "$README_FILE"
    sed -i '' "s/build-[0-9][0-9]*-blue/build-$NEW_BUILD-blue/" "$README_FILE"
else
    # Linux
    sed -i "s/version-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*-blue/version-$NEW_VERSION-blue/" "$README_FILE"
    sed -i "s/build-[0-9][0-9]*-blue/build-$NEW_BUILD-blue/" "$README_FILE"
fi

echo "✓ Version updated to $FULL_VERSION (semantic: $NEW_VERSION, build: $NEW_BUILD)"
echo "✓ Updated $PUBSPEC_FILE and $README_FILE"
