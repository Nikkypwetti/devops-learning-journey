Your "Setup" Step (Do this now)

Open your terminal (Ctrl + Alt + T) and run these commands to ensure you have the core tools for the Month 1 Roadmap:

    Update your system:
    Bash

sudo apt update && sudo apt upgrade -y

Install the "Swiss Army Knife" tools:
Bash

sudo apt install -y git curl vim net-tools build-essential

Create your practice arena:
Bash

    mkdir ~/devops-journey
    cd ~/devops-journey

You are now ready.

Since you are on Ubuntu, would you like to start Week 1, Day 1 right now with the navigation commands?

yes

Great. Let's get your hands dirty.

Open your terminal (Ctrl + Alt + T). We are going to master Navigation.

In a graphical interface (like Windows Explorer), you "double-click" folders to move around. In the terminal, you are blind. You must use commands to "see" where you are and "teleport" to where you want to go.
The Mental Model

Linux is organized like a tree. The "Root" (/) is the bottom of the tree. Everything else branches off from there.
Step 1: Where am I?

Type this command and hit Enter:
Bash

pwd

    Meaning: "Print Working Directory".

    Output: You should see something like /home/yourname or /home/yourname/devops-journey. This is your current location.

Step 2: Look Around

Now, let's see what is in this folder.
Bash

ls

    Meaning: "List".

    Output: Likely nothing (if you just created the folder), or a list of files.

Now try this one to see "hidden" secrets:
Bash

ls -la

    Meaning: List (ls) ALL files (-a) in Long format (-l).

    Note: Files starting with a dot (like .bashrc) are hidden files.

Step 3: Moving Around

We are going to go up the tree, look around, and come back.

    Go up one level:
    Bash

cd ..

( .. always means "the folder above this one" )

Check where you are:
Bash

pwd

(You should now be in /home or the parent directory)

Go back home: No matter where you get lost in the system, this command teleports you instantly to your home folder:
Bash

    cd ~

Step 4: Creating a Structure (Hands-on Practice)

Let's build a practice environment inside your devops-journey folder. Run these commands one by one:

    Go to your folder:
    Bash

cd ~/devops-journey

Create three folders at once:
Bash

mkdir frontend backend database

Go inside the frontend folder:
Bash

cd frontend

Create an empty file:
Bash

touch index.html

Go back to the devops-journey folder:
Bash

    cd ..

🏆 Mini-Challenge

Prove you did it. I want you to run one single command that lists everything inside devops-journey (including the files inside the sub-folders) and paste the output here.

Hint: You need to use ls with the "Recursive" flag (-R).

Type ls -R and verify you see your folders and the index.html file. Did it work?

is this correct nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ ls -R

.:

backend  database  frontend


./backend:


./database:


./frontend:

index.html

nikky-techies@HP-EliteBook-820-G3:~/devops-journey

Yes, that is 100% correct! 🎉

You successfully:

    Created the directory structure.

    Navigated into a subdirectory (frontend).

    Created a file (index.html).

    Used the recursive flag (-R) to verify your entire structure at once.

You have passed Day 1.
Week 1, Day 2: Manipulate (Copy, Move, Destroy)

Now that you can navigate, you need to learn how to manage files. This is where you will spend 80% of your time in the terminal.

⚠️ Warning: You are on your main computer. Be very careful with the rm (remove) command. There is no Recycle Bin in the terminal. When you delete a file here, it is gone forever.
1. Renaming & Moving (mv)

In Linux, "Renaming" and "Moving" are the exact same command.

    Move: mv file.txt folder/ (Moves file into folder).

    Rename: mv oldname.txt newname.txt (Moves file to a new name).

Try it: Let's rename your index.html to home.html.
Bash

cd ~/devops-journey/frontend
mv index.html home.html
ls

(You should see home.html now).
2. Copying (cp)

Make a duplicate.

    File: cp source.txt destination.txt

    Folder: cp -r source_folder/ destination_folder/ (You need -r for "recursive" to copy folders).

Try it: Let's make a backup of your file.
Bash

cp home.html home.html.bak
ls

(You should now see two files: the original and the .bak backup).
3. Deleting (rm) - The Dangerous One

    File: rm file.txt

    Folder: rm -r foldername

Try it (Safely): Let's delete that backup file we just created.
Bash

rm home.html.bak
ls

(It should be gone).
🏆 Day 2 Challenge: The "Deployment" Simulation

Let's simulate a very common DevOps task: moving a file from a "build" folder to a "production" folder.

    Make sure you are in ~/devops-journey.

    Create a file named app.py inside the backend folder.

    Move that app.py file from backend to the frontend folder (I know this doesn't make sense logically, but it tests your path skills!).

    Rename the file inside frontend from app.py to static_script.py.

    Delete the now-empty backend folder.

Hint: You can do step 3 with a command like mv backend/app.py frontend/.

Run the commands, then show me the output of ls -R again so I can check your work!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/frontend$ cd ~/devops-journey

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ cd backend

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/backend$ touch app.py

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/backend$ ls

app.py

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/backend$ mv backend/app.py frontend/

mv: cannot stat 'backend/app.py': No such file or directory

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/backend$ mv app.py frontend/

mv: cannot move 'app.py' to 'frontend/': Not a directory

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/backend$ cd ~/devops-journey/frontend

mv app.py frontend/    

ls

mv: cannot stat 'app.py': No such file or directory

home.html

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/frontend$ cd backend

bash: cd: backend: No such file or directory

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/frontend$ 

did i get this right

You are very close, but you got tripped up by Relative Paths. This is the #1 confusion for beginners, so don't worry!

Let's look at exactly why it failed:

    The Error: mv: cannot move 'app.py' to 'frontend/': Not a directory

    The Reason: You were standing inside the backend folder.

        You told Linux: "Look for a folder named frontend inside this backend folder."

        Linux looked around backend, didn't see frontend, and gave up.

frontend lives one level up, next door to backend.
How to Fix It

The easiest way to fix this is to always return to your "Hub" (the main folder) before running commands that involve multiple folders.

Run these commands exactly to finish the challenge:

    Go back to the Hub:
    Bash

cd ~/devops-journey

(Now you are standing above both frontend and backend. You can see both.)

Move the file: Now your previous command will work because the path is correct from here.
Bash

mv backend/app.py frontend/

Go into frontend and rename:
Bash

cd frontend
mv app.py static_script.py

Go back and delete backend:
Bash

    cd ..
    rm -r backend

Now, run ls -R one last time and paste the result. You should see frontend (with the new file) and NO backend folder.

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ ls -R

.:

database  frontend


./database:


./frontend:

home.html  static_script.py

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$

Perfect execution. 💯

You have officially passed the "File Manipulation" stage.

    Backend folder? Gone.

    File moved? Yes.

    File renamed? Yes.

You are now ready for Day 3.
Week 1, Day 3: The Art of Reading Logs

As a DevOps engineer, you will spend hours staring at server logs to figure out why something crashed.

    Problem: Some log files are 10GBs in size. You cannot open them in a text editor (it will crash your computer).

    Solution: You need tools to "peek" inside files without opening the whole thing.

Step 1: Create a "Fake" Log File

First, we need a large file to practice on. Copy and paste this entire block into your terminal and hit Enter. It uses a loop to create a file with 100 lines of text.
Bash

cd ~/devops-journey
for i in {1..100}; do echo "Server Error Log Number $i: Critical Failure" >> error.log; done

(Verify it exists by typing ls. You should see error.log)
Step 2: The Tools

1. The "Dump" (cat) Dumps the entire file onto your screen.
Bash

cat error.log

    Result: Chaos. It scrolls too fast. You can't read the beginning. This is bad for huge files.

2. The "Peek Top" (head) Shows only the first 10 lines. Great for checking the format of a file.
Bash

head error.log

    Try: head -n 5 error.log (Shows only first 5 lines).

3. The "Peek Bottom" (tail) - 🌟 MOST IMPORTANT Shows the last 10 lines.

    Why is this vital? When a server crashes, the error is usually at the very end of the log file.

Bash

tail error.log

4. The "Book Reader" (less) Opens the file in a scrollable view.
Bash

less error.log

    Controls:

        Use Arrow Keys to scroll up/down.

        Press q to Quit/Exit.

🏆 Day 3 Challenge: The Investigation

I have a task for you that combines everything.

    Use tail to see the last 5 lines of your error.log.

    Then, use the redirection symbol > (which we hinted at earlier) to save only those last 5 lines into a new file called urgent_report.txt.

The Command to figure out: tail -n [number] [filename] > [new_filename]

Run that, and then use cat to read your new urgent_report.txt. Paste the output here!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ less error.log

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ tail -n 5 error.log > urgent_report.txt

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ cat urgent_report.txt

Server Error Log Number 96: Critical Failure

Server Error Log Number 97: Critical Failure

Server Error Log Number 98: Critical Failure

Server Error Log Number 99: Critical Failure

Server Error Log Number 100: Critical Failure

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ 

Spot on. 🎯

You have successfully:

    Used tail to grab specific data.

    Used > (Redirection) to save that output to a file.

    Verified it with cat.

This is a daily task for a DevOps engineer. You are doing it.
Week 1, Day 4: The Text Editor (Nano)

So far, you have created files using touch (empty) or echo (simple text). But real work requires editing complex configuration files. Servers don't have Microsoft Word or Notepad. They have terminal editors.

We will start with Nano. It is the easiest, most beginner-friendly editor.
The Controls

Nano uses keyboard shortcuts. The ^ symbol you see on the screen stands for the Ctrl key.

    Save: Ctrl + O (Write Out), then Enter.

    Exit: Ctrl + X.

Step 1: Open the file

Let's edit that report you just made.
Bash

nano urgent_report.txt

(Your screen will change. You are now inside the editor).
Step 2: Edit the file

    Use your Arrow Keys to move to the very top.

    Type: --- INCIDENT REPORT --- and press Enter twice.

    Move to the bottom line (Log Number 100).

    Delete the words "Critical Failure" (using Backspace) and type SOLVED.

Step 3: Save and Exit

    Press Ctrl + O (to save).

    It will ask: File Name to Write: urgent_report.txt. Press Enter to confirm.

    Press Ctrl + X (to exit).

🏆 Day 4 Challenge: The Config File

Real DevOps engineers edit "conf" (configuration) files. Let's pretend home.html is a config file.

    Open your home.html file (inside the frontend folder) using nano.

        Hint: nano frontend/home.html

    Change the text inside from <h1>I am a DevOps Engineer</h1> to <h1>I am a Linux Master</h1>.

    Save and exit.

    Use cat to verify the change.

Paste the output of your cat command here!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/frontend$ cat home.html

<h1>I am a Linux Master</h1>

nikky-techies@HP-EliteBook-820-G3:~/devops-journey/frontend$ 

Mission Accomplished. 🎖️

You have now mastered the basics of interacting with files: Creating, Moving, Deleting, Reading, and Editing.

Now we move to the topic that confuses 90% of beginners: Permissions.
Week 1, Day 5: Permissions (chmod)

In Linux, you can't just run any file you want. You need permission.
Step 1: The Anatomy of ls -l

Go to your devops-journey folder and run this:
Bash

ls -l urgent_report.txt

You will see something like this: -rw-rw-r-- 1 nikky-techies nikky-techies 300 Dec 20 12:30 urgent_report.txt

Focus on that first weird string: -rw-rw-r-- It is split into 3 groups of 3 characters:

    Owner (You): rw- (You can Read and Write, but not Execute).

    Group: rw- (Your group can Read and Write).

    Everyone Else: r-- (Strangers can only Read).

Step 2: The "Execute" Problem

Let's create a script and try to run it.

    Create a file named hello.sh:
    Bash

echo "echo 'Hello Nikky!'" > hello.sh

Try to run it:
Bash

    ./hello.sh

Result: bash: ./hello.sh: Permission denied ❌ Why? Because Linux does not trust new files by default. It assumes they are just text, not programs.
Step 3: The Fix (chmod)

We need to add the eXecute (x) permission.

We use chmod (Change Mode).

    +x adds execute permission.

    -x removes execute permission.

Run this:
Bash

chmod +x hello.sh

Now look at the permissions again:
Bash

ls -l hello.sh

You should see -rwxrwxr-x (Note the x's are now there, and the filename might turn green).

Now run it:
Bash

./hello.sh

Result: Hello Nikky! ✅
🏆 Day 5 Challenge: The "Security Lockdown"

This is a very common interview question scenario: "How do you make a file private so ONLY you can read it?"

    Create a file named secret_key.txt and put the text "12345" inside it.

    Check the current permissions (ls -l). Everyone can likely read it (r-- at the end).

    The Task: Change the permissions so that ONLY YOU can read and write it. No one else (Group or Others) should have any permissions (no r, no w, no x).

Hint:

    Read = 4

    Write = 2

    Execute = 1

    You want Read+Write (4+2=6) for yourself.

    You want Zero (0) for Group.

    You want Zero (0) for Others.

    So the magic number is 600.

Command: chmod 600 [filename]

Run the commands and paste the output of ls -l secret_key.txt to prove it is locked down!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ chmod 600 secret_key.txt 

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ ls -l secret_key.txt

-rw------- 1 nikky-techies nikky-techies 13 Dec 20 12:42 secret_key.txt

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ 

Perfect. 🔒

-rw-------. That means:

    User: Read/Write.

    Group: Nothing.

    Others: Nothing.

You have secured the file.
Week 1, Day 6: The Superuser (sudo)

You have mastered your own files. But what if you want to change the system?

In Windows, you sometimes get a popup: "Do you want to allow this app to make changes to your device?" In Linux, we don't have popups. We have sudo.

sudo = SuperUser DO.

It temporarily gives you the powers of the "Root" user (the God of the system) for one single command.
Step 1: The "Permission Denied" (Again)

Let's try to update the system without permission.
Bash

apt update

Result: E: Could not open lock file... Permission denied. Why? Because apt (the tool that installs apps) tries to modify system folders that you (nikky-techies) do not own. Root owns them.
Step 2: The Magic Word

Now, ask politely using sudo.
Bash

sudo apt update

    It will ask for your password. Note: When you type your password in Linux, no stars or dots will appear. It looks like you are typing nothing. This is a security feature. Just type it blind and hit Enter.

🏆 Day 6 Challenge: Install a Matrix Screen

We are going to install a program called cmatrix. It serves no purpose other than looking cool (like the Matrix movie code rain).

    Install it: Run the install command with sudo permissions.
    Bash

sudo apt install cmatrix

(Type y and Enter if it asks to confirm).

Run it: Type cmatrix and hit Enter. (Enjoy the show. Press Ctrl + C to exit).

Prove it: I want you to show me where this program was installed on your hard drive. Run this command:
Bash

    which cmatrix

Paste the output of which cmatrix here!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ cmatrix

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ which cmatrix

/usr/bin/cmatrix

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ 

Correct! /usr/bin/ is where Linux keeps the programs that everyone on the system is allowed to use. You are now officially dangerous—you can install software and run it.
Week 1, Day 7: Networking Basics (The Grand Finale)

To finish Week 1, we need to learn how your Linux machine talks to the world. In the cloud, a server without a network connection is useless.
1. Who am I? (ip)

You need to know your own address.

    Command: ip a (short for ip address).

    What to look for:

        lo (Loopback): Usually 127.0.0.1. This is "yourself". If you talk to this IP, you are talking to your own machine.

        wlp... or eth...: This is your Wi-Fi or Ethernet card. Look for inet followed by a number like 192.168.x.x or 10.x.x.x. That is your Private IP.

2. Can you hear me? (ping)

This checks if a remote server is alive and reachable.

    Command: ping google.com

    Output: It sends small data packets. If you see lines like 64 bytes from... time=20ms, it's working.

    Stop it: Linux ping goes forever. Press Ctrl + C to stop it.

3. Fetching Data (curl)

This is like a web browser, but for the terminal. It downloads code or text from a URL.

    Command: curl https://www.google.com

    Output: A mess of HTML code.

🏆 Week 1 Final Challenge: The "Public Identity"

There is a difference between your Private IP (what your router gives you) and your Public IP (what the internet sees).

    Check Private IP: Run ip a and identify your local IP (likely starts with 192 or 10).

    Check Public IP: You cannot find this on your computer; you have to ask an external server.

        Run this command: curl ifconfig.me

    The Task: I want you to run a single command that prints: "My Public IP is: [Your IP]".

Hint: You can combine echo and curl using command substitution $(). Example: echo "My Date is: $(date)"

Figure out the command to print your Public IP and paste the result here!

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ echo "echo My Public IP is: $(IP)"

IP: command not found

echo My Public IP is: 

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ echo "echo My Public IP is: $(102.89.83.228)"

102.89.83.228: command not found

echo My Public IP is: 

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ 

You are very close! You actually found your IP (102.89.83.228), but the syntax for the command substitution got a little mixed up.
The Fix

The $( ... ) syntax tells Linux: "Run the command inside these parentheses, grab the result, and paste it right here."

    Your attempt: $(102.89.83.228) -> Linux tried to run a program named "102.89.83.228". It doesn't exist.

    The solution: You need to put the command that gets the IP inside the parentheses.

Run this command:
Bash

echo "My Public IP is: $(curl -s ifconfig.me)"

(Note: I added -s to curl to make it "silent" so it doesn't show the download progress bar, just the IP).

Try that and paste the final successful output!

ikky-techies@HP-EliteBook-820-G3:~/devops-journey$ echo "My Public IP is: $(curl -s ifconfig.me)"

My Public IP is: 102.89.83.228

nikky-techies@HP-EliteBook-820-G3:~/devops-journey$ 

Congratulations! 🎓

You have officially completed Week 1: Linux Foundation.

You started as a complete beginner in the terminal, and in just a short time, you have learned to:

    ✅ Navigate the file system without a mouse (cd, ls).

    ✅ Manipulate files and folders (touch, mkdir, mv, rm).

    ✅ Read & Edit files (cat, tail, nano).

    ✅ Control Permissions (chmod, sudo).

    ✅ Inspect Networking (ip, ping, curl).

This is the bedrock of DevOps. Every server you touch for the rest of your career will require these skills.