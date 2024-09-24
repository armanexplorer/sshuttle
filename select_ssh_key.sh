#!/bin/bash

# Directory where the SSH keys are stored
SSH_DIR="$HOME/.ssh"

# Check if the .ssh directory exists
if [ ! -d "$SSH_DIR" ]; then
    echo "No .ssh directory found in $HOME" >&2
    exit 1
fi

# Find all SSH private key files based on common key file names
keys=( "$SSH_DIR/id_rsa" "$SSH_DIR/id_dsa" "$SSH_DIR/id_ecdsa" "$SSH_DIR/id_ed25519" )

# Filter out keys that do not exist
existing_keys=()
for key in "${keys[@]}"; do
    if [ -f "$key" ]; then
        existing_keys+=("$key")
    fi
done

# Add any other keys that have the correct file permissions (0400 or 0600) in the .ssh directory to the list
for key in "$SSH_DIR"/*; do
    if [[ -f "$key" && "$key" != *.pub && "$key" != *known_hosts* && ( "$(stat -c %a "$key")" == "400" || "$(stat -c %a "$key")" == "600" ) ]]; then
        if [[ ! " ${existing_keys[*]} " =~ " ${key} " ]]; then
            existing_keys+=("$key")
        fi
    fi
done

# Check if there are any existing keys found
if [ ${#existing_keys[@]} -eq 0 ]; then
    echo "No SSH keys found in $SSH_DIR" >&2
    exit 1
fi

# Display the list of keys to the user
select key in "${existing_keys[@]}"; do
    if [ -n "$key" ]; then
        export SELECTED_SSH_KEY="$key"  # Set the environment variable
        break
    else
        echo "Invalid selection. Please try again." >&2
    fi
done