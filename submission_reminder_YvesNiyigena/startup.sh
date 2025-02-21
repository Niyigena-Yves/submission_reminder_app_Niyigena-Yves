#!/bin/bash

# Check if all required files exist
check_files() {
    local required_files=(
        "./config/config.env"
        "./modules/functions.sh"
        "./app/reminder.sh"
        "./assets/submissions.txt"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo "Error: Required file $file not found!"
            return 1
        fi
    done
    return 0
}

# Main startup logic
echo "Starting Submission Reminder Application..."
echo "----------------------------------------"

if check_files; then
    # Change to app directory and execute the reminder script
    cd app
    ./reminder.sh
else
    echo "Setup incomplete. Please ensure all required files are present."
    exit 1
fi
