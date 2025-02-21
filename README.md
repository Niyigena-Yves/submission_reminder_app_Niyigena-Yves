
# Submission Reminder Application

A shell script application that helps track and send reminders for assignment submissions.

Setup Instructions

1. Clone the repository:
   git clone https://github.com/yourusername/submission_reminder_app_githubusername.git
   
   cd submission_reminder_app_githubusername

3. Make the environment creation script executable:
chmod +x create_environment.sh

4. Run the setup script:
./create_environment.sh

You will be prompted to enter your name
The script will create a directory named submission_reminder_yourname

submission_reminder_yourname/
       app/reminder.sh
       modules/functions.sh
       assets/submissions.txt
       config/config.env
       startup.sh

4. Running the Application

Navigate to your submission reminder directory:
cd submission_reminder_yourname

Run the application:
./startup.sh
