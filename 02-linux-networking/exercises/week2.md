Week 2, Day 1: Hello Bash

What is a Bash Script? It is just a text file containing a list of commands. Instead of typing mkdir folder, then cd folder, then touch file one by one, you write them all in a file, run the file, and Linux does them all instantly.
Step 1: Create the File

We need a place to work.
Bash

cd ~/devops-journey
mkdir scripts
cd scripts

Now create your first script file using nano. Script files usually end with .sh.
Bash

nano hello.sh

Step 2: The "Shebang" (Crucial)

The very first line of any bash script must be this: #!/bin/bash

    #! is called the "Shebang".

    It tells Linux: "Don't just read this text; use the Bash program located at /bin/bash to execute these commands."

Type this into your nano editor:
Bash

#!/bin/bash

echo "--------------------------------"
echo "Hello! I am a script."
echo "I am running on this computer:"
uname -n
echo "--------------------------------"

Save and exit (Ctrl+O, Enter, Ctrl+X).
Step 3: The Permission Problem (Review)

Try to run it:
Bash

./hello.sh

    Error: Permission denied.

    Why? Remember Week 1? Linux doesn't trust new files.

    Fix: Give it "Execute" (+x) permission.

Bash

chmod +x hello.sh

Step 4: Run It

Now run it again.
Bash

./hello.sh

    Note: The ./ means "look in the current directory for this file". If you just type hello.sh, Linux will look in the system folders (like /usr/bin) and fail to find it.

🏆 Day 1 Challenge: Variables

Hard-coding text is boring. Let's make the script smarter using Variables.

    Syntax: NAME="Nikky" (No spaces around the = sign!).

    Use it: echo "Hello $NAME".

Your Mission:

    Edit hello.sh again.

    Create a variable called CURRENT_USER and set it to your username (or use the command whoami inside $() like we did with the IP address).

    Make the script say: "Hello [Your Name], the date is [Current Date]".

Hint:

    You can get the date using the date command.

    Example line: echo "The date is $(date)"

Edit your script, run it, and paste the output here!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./hello.sh

--------------------------------

Hello! I am a script.

I am running on this computer:

HP-EliteBook-820-G3

--------------------------------

CURRENT_USER: nikky-techies

The date is: Sat Dec 20 01:43:59 PM WAT 2025

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

Success! 🚀

You successfully combined static text, variables, and system commands (uname, date) into a single executable tool. This is the "Hello World" of automation.

Now, let's make your scripts smart.
Week 2, Day 2: Input & Logic (read & if)

Right now, your script does the exact same thing every time. Real scripts need to make decisions.

    "If the backup fails, email me."

    "If the disk is full, delete old logs."

To do this, we need Input and Logic.
1. Getting Input (read)

The read command pauses the script and waits for the user to type something.

    Syntax: read -p "Question? " VARIABLE_NAME

Try it: Create a new file interactive.sh:
Bash

#!/bin/bash
read -p "What is your name? " USER_NAME
echo "Nice to meet you, $USER_NAME!"

(Don't forget chmod +x interactive.sh before running it!)
2. Making Decisions (if / else)

This is the brain of the script.

Syntax:
Bash

if [ condition ]; then
    # do something
else
    # do something else
fi

Important: You MUST put spaces inside the brackets [ condition ].

    Correct: [ "$NAME" == "Nikky" ]

    Wrong: ["$NAME"=="Nikky"] (This will crash).

🏆 Day 2 Challenge: The "Server Gatekeeper"

You are going to write a script that simulates a secure login.

    Create a file named login.sh.

    Ask the user: "Please enter your username:"

    The Logic:

        IF the user types admin, the script should say: "Welcome, Administrator. You have root access."

        ELSE, the script should say: "Error: User [Name] is not authorized."

Hint: Your condition line should look like this: if [ "$USER" == "admin" ]; then

Write the script, make it executable, run it twice (once as "admin" and once as "nikky"), and paste the output!

ikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./interactive.sh

What is your name? Nikky

Nice to meet you, Nikky!

./interactive.sh: line 6: syntax error near unexpected token `else'

./interactive.sh: line 6: `else'

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

It looks like you have a small syntax error. In Bash, the computer is very picky about grammar!

The error syntax error near unexpected token 'else' usually means you forgot the word then or you didn't close the block with fi.

Here is the correct structure for an if statement. Notice the keywords if, then, else, and fi.
The Fix

Open your file again (nano login.sh) and make sure it looks exactly like this:
Bash

#!/bin/bash

read -p "Please enter your username: " USER

if [ "$USER" == "admin" ]; then
    echo "Welcome, Administrator. You have root access."
else
    echo "Error: User $USER is not authorized."
fi

Key things to check:

    Did you put ; then after the condition? (Or put then on the next line).

    Did you put spaces inside the brackets? [ "$USER" == "admin" ] is correct. ["$USER"=="admin"] is wrong.

    Did you end the whole thing with fi (which is "if" backwards)?

Try fixing your script, and run it again!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ echo "echo 'hello'" > login.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ nano login.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ chmod +x login.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ nano login.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./login.sh

Please enter your username? admin

./login.sh: line 5: syntax error near unexpected token `else'

./login.sh: line 5: `else'

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ nano login.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./login.sh

Please enter your username? admin

Welcome, Administrator. You have root access.

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./login.sh

Please enter your username? nikky

Error: User nikky is not authorized.

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ nano interactive.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./interactive.sh

What is your name? Nikky

You are not Nikky

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ nano interactive.sh

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./interactive.sh

What is your name? Nikky

Nice to meet you, Nikky!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./interactive.sh

What is your name? ola

You are not ola

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

You fixed it! 👏

I watched your logs there—you encountered the syntax error, went back into nano, found the missing piece (likely the ; then or the closing fi), and fixed it yourself. That specific cycle—Break, Debug, Fix—is exactly what this job is about.

You have now mastered:

    Variables: Storing data.

    Input: Talking to the user.

    Logic: Making decisions (if/else).

Now, let's make you powerful.
Week 2, Day 3: Loops (for)

Imagine you need to create 100 user accounts. You are NOT going to type the useradd command 100 times. You write one command and loop it 100 times.
The "For" Loop

This is the most common loop. It says: "For every item in this list, do these steps."

Syntax:
Bash

for variable in list
do
   command 1
   command 2
done

Step 1: The Practice Loop

Create a new file named loops.sh.
Bash

#!/bin/bash

# Simple loop from 1 to 5
for number in {1..5}
do
    echo "This is loop number $number"
    sleep 1   # Pause for 1 second to make it dramatic
done

echo "Loop finished!"

(Don't forget chmod +x loops.sh).

Run it. You will see it count up: 1, 2, 3, 4, 5.
🏆 Day 3 Challenge: The "Batch Creator"

You are going to write a script that generates dummy files. This is useful for testing how your system handles disk usage or file processing.

Your Mission:

    Create a script named maker.sh.

    The script should create a new folder named test_files.

    Inside that folder, use a Loop to create 10 files named file1.txt, file2.txt ... up to file10.txt.

    Inside each file, simply put the text "Test Data".

Hint:

    You will need mkdir.

    You will need a loop for i in {1..10}.

    Inside the loop, use touch or redirection > to create the file.

        Example: echo "Test Data" > test_files/file$i.txt

Write it, run it, and then run ls test_files to prove you created 10 files instantly.

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ mkdir maker.sh test_files

mkdir: cannot create directory ‘maker.sh’: File exists

It looks like you made a small mix-up between creating files and folders.

    The Error: You ran mkdir maker.sh. This tries to make a folder named "maker.sh". But you probably already have a file with that name, or you simply shouldn't be making a folder for your script.

    The Fix: Scripts are text files, not folders. We use nano or touch to create them, not mkdir.

Here is how to clear the mess and do it right:

    Remove the mistake (if it's a folder):
    Bash

rm -r maker.sh

(If it says "No such file", that's fine, just move to step 2).

Create the script file correctly:
Bash

nano maker.sh

Type this code inside the editor:
Bash

#!/bin/bash

# 1. Create the directory for the files
mkdir -p test_files

# 2. Loop 10 times
for i in {1..10}
do
    echo "Creating file number $i"
    echo "Test Data" > test_files/file$i.txt
done

echo "All done! Check the test_files folder."

Save and Exit: (Ctrl+O, Enter, Ctrl+X).

Run it:
Bash

    chmod +x maker.sh
    ./maker.sh

After you run it, check your work by typing ls test_files. You should see 10 files!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ls test_files

file10.txt  file2.txt  file4.txt  file6.txt  file8.txt

file1.txt   file3.txt  file5.txt  file7.txt  file9.txt

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

Boom. 💥

You just created 10 files in milliseconds. Imagine if that was 10,000 files. You would have done it just as fast, while a manual user would still be clicking "New Folder."

You have mastered Loops.
Week 2, Day 4: Cron Jobs (The Time Traveller)

You have written scripts, but you still have to run them manually (./maker.sh). True DevOps means the server does the work while you are sleeping.

Enter Cron. Cron is the alarm clock of Linux. You tell it when to wake up and what to do.
1. The Syntax (The 5 Stars)

A cron job looks like a row of 5 stars followed by a command:

* * * * * /path/to/script.sh

The stars represent time units:

    Minute (0-59)

    Hour (0-23)

    Day of Month (1-31)

    Month (1-12)

    Day of Week (0-7, where 0 is Sunday)

Examples:

    0 5 * * * = Run at 5:00 AM every day.

    30 17 * * 5 = Run at 5:30 PM every Friday.

    * * * * * = Run every single minute.

2. Editing Cron (crontab)

You don't edit a file directly. You use the cron table editor.

Command:
Bash

crontab -e

(If it asks you to choose an editor, press 1 for Nano).
🏆 Day 4 Challenge: The "Heartbeat"

We are going to make a "heartbeat" monitor. We will tell Linux to write the current date into a log file every single minute, forever.

    Open Cron:
    Bash

crontab -e

Add the Job: Scroll to the very bottom of the file (past all the blue comments). Add this line exactly:
Bash

* * * * * date >> ~/heartbeat.log

Save and Exit: Same as Nano (Ctrl+O, Enter, Ctrl+X). You should see a message: crontab: installing new crontab.

The Wait: Now... wait. Do nothing for 2 minutes. The system is working in the background.

The Reveal: After 2 minutes, check your home folder:
Bash

    cat ~/heartbeat.log

Do this, wait, and then show me the output of the log!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ cat ~/heartbeat.log

Sat Dec 20 02:52:01 PM WAT 2025

Sat Dec 20 02:53:01 PM WAT 2025

Sat Dec 20 02:54:01 PM WAT 2025

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

It works! 🤖

Your computer is now executing tasks automatically without your help. This is the definition of "Server Automation."
⚠️ Important: The Cleanup

If we leave this running, that file will grow larger every minute forever. Let's learn how to stop a Cron Job.

    Run crontab -e.

    Delete the line you added (or put a # in front of it to "comment it out" and disable it).

    Save and exit.

Week 2, Day 5: The "Exit Status" ($?)

How does one script know if another script failed? It checks the Exit Code.

Every command in Linux sends a secret signal when it finishes:

    0 = Success (Everything is good).

    Not 0 (1, 2, 127, etc.) = Failure (Something went wrong).

You can see this secret number using the variable $?.
Step 1: The Experiment

    Run a command that works:
    Bash

ls
echo $?

Result: You should see 0.

Run a command that fails (list a missing folder):
Bash

    ls /missing-folder
    echo $?

    Result: You will see 2 (or another non-zero number).

🏆 Day 5 Challenge: The "Site Monitor"

You are going to write a script that checks if a website is online. This is the primitive version of tools like Nagios or Datadog.

Your Mission:

    Create monitor.sh.

    The script should try to ping https://www.google.com/url?sa=E&source=gmail&q=google.com only once (-c 1).

    The Logic:

        Check the exit code $?.

        IF the code is 0 (Success), print: "Google is UP!"

        ELSE, print: "Google is DOWN!"

Hint: It’s tricky to capture $? because it disappears after the very next command. Structure it like this:
Bash

ping -c 1 google.com
if [ $? -eq 0 ]; then
   # success code
else
   # failure code
fi

Write it, run it (while connected to the internet), and show me the result!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./monitor.sh

PING google.com (216.58.214.174) 56(84) bytes of data.

64 bytes from par10s42-in-f14.1e100.net (216.58.214.174): icmp_seq=1 ttl=110 time=152 ms


--- google.com ping statistics ---

1 packets transmitted, 1 received, 0% packet loss, time 0ms

rtt min/avg/max/mdev = 152.391/152.391/152.391/0.000 ms

./monitor.sh: line 3: print:: command not found

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

You are almost there! You logic works perfectly (the ping succeeded), but you used a command that doesn't exist in Bash.

The Error: print:: command not found The Reason: In Python or other languages, you might use print. In Bash, the command to talk to the screen is always echo.
The Fix

Open your script (nano monitor.sh) and replace the word print: with echo.

It should look like this:
Bash

#!/bin/bash

ping -c 1 google.com

if [ $? -eq 0 ]; then
   echo "Google is UP!"
else
   echo "Google is DOWN!"
fi

Make that small change, run it again, and you will see the victory message!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./monitor.sh

PING google.com (216.58.214.174) 56(84) bytes of data.

64 bytes from par10s42-in-f14.1e100.net (216.58.214.174): icmp_seq=1 ttl=110 time=347 ms


--- google.com ping statistics ---

1 packets transmitted, 1 received, 0% packet loss, time 0ms

rtt min/avg/max/mdev = 347.382/347.382/347.382/0.000 ms

Google is UP!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ 

Excellent work. ✅

You have successfully built a functional monitoring tool. In the real world, this logic is exactly how load balancers decide if a server is healthy enough to receive traffic.

You have now mastered the core pillars of Bash Scripting:

    Variables ($NAME)

    Input (read)

    Loops (for)

    Logic (if/else)

    Exit Codes ($?)

Week 2 Grand Finale: The "Auto-Backup" Project

It is time to combine everything you have learned in Linux (Week 1) and Scripting (Week 2) into one professional-grade tool.

The Scenario: You are the DevOps Engineer for a company. The developers keep losing their work. Your boss wants a script that:

    Takes a specific folder.

    Compresses it into a .tar.gz (zip) file.

    Saves it to a backup location.

    Adds a timestamp so we know when the backup happened.

Your Mission: Create backup.sh. I will give you the skeleton, but you must fill in the blanks.
Step 1: The Setup

Create the directories we need for the simulation.
Bash

cd ~/devops-journey
mkdir work_to_backup
mkdir backups
touch work_to_backup/file1.txt work_to_backup/file2.txt

Step 2: The Code (Fill in the ___)

Create backup.sh inside your scripts folder. Read the comments carefully to know what to type in the blanks.
Bash

#!/bin/bash

# 1. Define variables
SOURCE_DIR="$HOME/devops-journey/work_to_backup"
BACKUP_DIR="$HOME/devops-journey/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

echo "Starting backup for: $SOURCE_DIR"

# 2. Check if the source directory actually exists
if [ -d "$SOURCE_DIR" ]; then
    echo "Source directory found. Proceeding..."
else
    echo "Error: Directory $SOURCE_DIR does not exist."
    exit 1
fi

# 3. Create the compressed file
# Syntax: tar -czf [output_file] [input_folder]
echo "Compressing files..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

# 4. Check if the backup command succeeded
if [ $? -eq 0 ]; then
    echo "Backup Successful! File saved to: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "Backup Failed!"
fi

Copy this code into backup.sh. I have filled in the hard parts (like the tar command syntax) for you, but read it to understand the flow.

Run it, and then check your backups folder. You should see a new file with today's date in the name!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/scripts$ ./backup.sh

Starting backup for: /home/nikky-techies/devops-journey/work_to_backup

Source directory found. Proceeding.....

Congratulations! 🏆

You have successfully written and executed a professional-grade backup automation script.

Don't worry about that tar: Removing leading '/' message. That is actually a safety feature. It means if you extract this backup on another computer, it won't try to overwrite the root folders (like /home) immediately; it will extract them safely into your current folder. Your script worked perfectly.
Verify Your Victory

Let's verify the file is actually there and check its size. Run this:
Bash

ls -lh ~/devops-journey/backups

(You should see your .tar.gz file with a timestamp).
End of Month 1 (Weeks 1 & 2)

You have crushed the first third of the roadmap.

    Week 1: You mastered the Linux Terminal.

    Week 2: You mastered Bash Scripting & Automation.

You are no longer a "user." You are an Operator.