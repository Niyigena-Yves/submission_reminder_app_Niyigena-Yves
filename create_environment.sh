#!/bin/bash

# Function to validate directory name (remove spaces and special characters)
sanitize_name() {
    echo "$1" | tr -cd '[:alnum:]_-'
}

# Get user's name
echo "Please enter your name: "
read user_name

# Sanitize the user's name and create base directory name
sanitized_name=$(sanitize_name "$user_name")
base_dir="submission_reminder_${sanitized_name}"

# Create directory structure
echo "Creating application directory structure..."
mkdir -p "$base_dir"/{app,modules,assets,config}

# Create config.env
cat > "$base_dir/config/config.env" << 'EOL'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create functions.sh
cat > "$base_dir/modules/functions.sh" << 'EOL'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL

# Create reminder.sh in app directory
cat > "$base_dir/app/reminder.sh" << 'EOL'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

# Create submissions.txt with additional student records
cat > "$base_dir/assets/submissions.txt" << 'EOL'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Samuel, Shell Navigation, not submitted
Grace, Shell Navigation, submitted
Michael, Shell Navigation, not submitted
Jennifer, Shell Navigation, not submitted
David, Shell Navigation, submitted
Sarah, Shell Navigation, not submitted
EOL

# Create startup.sh
cat > "$base_dir/startup.sh" << 'EOL'
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
EOL

# Make scripts executable
chmod +x "$base_dir/app/reminder.sh"
chmod +x "$base_dir/modules/functions.sh"
chmod +x "$base_dir/startup.sh"

echo "Environment setup complete! Directory structure created in: $base_dir"
echo "To start the application, navigate to $base_dir and run: ./startup.sh"
