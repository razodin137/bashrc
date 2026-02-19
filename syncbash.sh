#!/bin/bash

# Define the target file (use ~/.zshrc if you use Zsh)
TARGET_FILE="$HOME/.bashrc"
# The marker we use to find our block in .bashrc
START_MARKER="# === GENESIS ALIASES START ==="
END_MARKER="# === GENESIS ALIASES END ==="

echo "🔄 Syncing Git aliases to $TARGET_FILE..."

# 1. Create a temporary file for the new aliases
TEMP_ALIASES=$(mktemp)

echo "$START_MARKER" >> "$TEMP_ALIASES"

# 2. Extract code from each .md file and append to temp file
# Add your specific file names here
for cmd in gtag gnew gnew-p gconnect; do
  FILE="commands/$cmd.md" # Adjust path if they are in /bashrc folder
  if [ -f "$FILE" ]; then
    echo "  -> Extracting $cmd..."
    # This sed command extracts text between the first set of ``` and ```
    sed -n '/^```/,/^```/{ /^```/d; p; }' "$FILE" >> "$TEMP_ALIASES"
    echo "" >> "$TEMP_ALIASES"
  else
    echo "  ⚠️ Warning: $FILE not found, skipping."
  fi
done

echo "$END_MARKER" >> "$TEMP_ALIASES"

# 3. Update .bashrc
if grep -q "$START_MARKER" "$TARGET_FILE"; then
  # Overwrite existing block: Delete everything between markers and replace
  sed -i "/$START_MARKER/,/$END_MARKER/d" "$TARGET_FILE"
  cat "$TEMP_ALIASES" >> "$TARGET_FILE"
else
  # Append new block for the first time
  cat "$TEMP_ALIASES" >> "$TARGET_FILE"
fi

rm "$TEMP_ALIASES"

echo "✅ Done! Run 'source $TARGET_FILE' to update your current session."
