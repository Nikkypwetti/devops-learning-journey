Day 13: Compose for Development (Hot Reload & Watch)
I. Technical Theory: Development vs. Production Flow

In professional DevOps, we use different "modes" for Docker Compose:

    Production Mode: You build the image, push it to a registry, and run it. If you change a line of code, you must rebuild the image.

    Development Mode (Compose Watch): You "sync" your local folder on your EliteBook directly into the running container.

    Hot Reload: This is a feature of your application framework (like Node.js or Angular) that detects file changes and restarts the internal server without restarting the container.

II. Deep Dive: Key Learning Points

    From Video: The video introduces docker compose watch. This new feature replaces the old way of manually creating complex bind mounts for every source folder.

    From Docs: * develop key: This is a new top-level key in your YAML where you define "watch" rules.

        Action types: * sync: Instantly copies files (best for frontend/backend code).

            rebuild: Rebuilds the image if a file like package.json changes.

            sync+restart: Copies files and restarts the container (best for heavy backend changes).

III. Professional Hands-on: Three-Tier Hot Reload

To implement this on your project, update your backend or frontend service in the docker-compose.yml.

1. The develop configuration:
YAML

services:
  backend:
    build: ./backend
    develop:
      watch:
        - action: sync
          path: ./backend
          target: /app
          ignore:
            - node_modules/
        - action: rebuild
          path: ./backend/package.json

2. The Command to Start:
Instead of docker compose up, you run the "Watch" mode:
Bash

docker compose watch

IV. Troubleshooting Log (Day 13 Setup)
Issue	Root Cause	Professional Fix
Changes not appearing	The application inside doesn't support hot reload (e.g., standard node instead of nodemon).	Update your Dockerfile CMD to use a dev runner like npm run dev.
Too many file changes	Watching the node_modules folder.	Always use the ignore: key to exclude heavy directories.
watch command not found	Using an outdated version of Docker Compose.	Run docker compose version. You need v2.22.0 or higher.
V. How to Understand it Perfectly (The "Day 11 & 12" Merge)

Think of Day 13 as the "Remote Control" for the work you did on Day 11 and 12.

    Day 11 (Volumes): Gave you a persistent hard drive for your data.

    Day 12 (Environment): Gave you a secure way to pass IDs and Passwords.

    Day 13 (Watch): Gives you a "live wire" to your code.

    The Result: You can change a CSS color in your frontend or a validation logic in your backend, and the result appears in your browser in less than 1 second.

Compiled Summary of Verified Commands
Bash

# 1. Verify your Docker Compose version (Must be 2.22+)
docker compose version

# 2. Start the stack in Watch mode
docker compose watch

# 3. Test Hot Reload
# Open backend/server.js on your EliteBook, change a log message, and save.
# Check your terminal—you should see "Syncing files..." immediately.

Day 13: Environment Configuration & Compose Watch
I. Technical Theory: Development Velocity

In a professional DevOps workflow, we distinguish between Production (static images) and Development (live code syncing).

    Compose Watch: A Docker Compose feature that monitors your host filesystem and automatically performs actions (syncing files or rebuilding images) when it detects a change.

    Hot Reload: This depends on your application. For a Node.js backend, you typically use nodemon. For an Angular/React frontend, the dev server handles it. Docker Compose simply moves the files; the app reloads them.

II. Deep Dive: Updating Your Code

You need to add the develop section to your Backend and Frontend services. The db service doesn't need it because its code (MongoDB) doesn't change.
YAML

  # 2. BACKEND SERVICE
  backend:
    build: ./backend
    image: nikkytechies/fiddly-backend:${BUILD_NUMBER:-latest}
    depends_on:
      db:
        condition: service_healthy
    environment:
      - DATABASE_URL=mongodb://${DB_USER}:${DB_PASSWORD}@db:27017/my_portfolio?authSource=admin
    develop:
      watch:
        - action: sync
          path: ./backend        # Watch this folder on your laptop
          target: /app           # Sync to this folder in the container
          ignore:
            - node_modules/     # Don't sync heavy dependencies
        - action: rebuild
          path: ./backend/package.json # Rebuild image only if dependencies change
    networks:
      - backend-nw
      - frontend-nw

  # 3. FRONTEND SERVICE
  frontend:
    build: ./frontend
    image: nikkytechies/fiddly-frontend:latest
    ports:
      - "80:80"
    develop:
      watch:
        - action: sync
          path: ./frontend
          target: /usr/share/nginx/html # Or your app directory
    networks:
      - frontend-nw

III. Professional Hands-on: Commands & Verification

To start the project in "Watch Mode," you use a specific command instead of the standard up:
Step	Command	DevOps Purpose
1. Start Watching	docker compose watch	Runs the services and begins monitoring file changes.
2. Verify Sync	docker compose logs -f	Watch the logs to see the app "Hot Reload" after a file save.
3. Check Version	docker compose version	Requirement: Must be version 2.22.0 or higher for Watch to work.
IV. Troubleshooting Log (Day 13)
Issue	Root Cause	Professional Fix
Files sync but no reload	Your application is running with node instead of nodemon.	Update your package.json script to use a watcher like nodemon server.js.
Permissions Error	Docker cannot write to the target directory.	Ensure the WORKDIR in your Dockerfile matches the target: path in your YAML.
Infinite Loop	Watching the node_modules or dist folders.	Always add node_modules/ to the ignore: section of the watch config.
V. How to Understand it Perfectly

Think of the standard docker compose up as a Photograph (it’s a frozen moment of your code).
Think of docker compose watch as a Live Stream.

    Day 11 (Volumes): Handled your database's long-term memory.

    Day 12 (Environment): Handled your security credentials.

    Day 13 (Watch): Handles your real-time creativity.
    By combining all three, you can build your portfolio in minutes instead of hours.

Day 13: Compose for Development (Part 2 - Hot Reload Logic)
I. Technical Theory: The Development Entrypoint

In a professional DevOps workflow, we often use a single Dockerfile but override the CMD (command) depending on the environment.

    Production: We use node server.js (Stable, low overhead).

    Development: We use nodemon server.js (Restarts on file change).

II. Deep Dive: Updating Your Backend Dockerfile

To make your backend "Watch-ready," update your backend/Dockerfile and package.json.

1. Update backend/package.json
Add a "dev" script so Docker knows how to start the watcher:
JSON

"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}

2. Update backend/Dockerfile
Ensure nodemon is installed. Using a global install in the Dockerfile is common for dev environments:
Dockerfile

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install && npm install -g nodemon
COPY . .
EXPOSE 3001
CMD ["npm", "run", "dev"]

III. Professional Hands-on: Merging with Compose Watch

Now, apply the Watch configuration to your docker-compose.yml. This connects the dots between your host files and the nodemon process inside.
YAML

  # 2. BACKEND SERVICE
  backend:
    build: ./backend
    image: nikkytechies/fiddly-backend:${BUILD_NUMBER:-latest}
    depends_on:
      db:
        condition: service_healthy
    environment:
      - DATABASE_URL=mongodb://${DB_USER}:${DB_PASSWORD}@db:27017/my_portfolio?authSource=admin
    develop:
      watch:
        - action: sync
          path: ./backend        # Watch your backend folder on the EliteBook
          target: /app           # Where it maps inside the container
          ignore:
            - node_modules/
        - action: rebuild
          path: ./backend/package.json # Rebuild image if you add new npm packages
    networks:
      - backend-nw
      - frontend-nw

IV. Troubleshooting Log (Day 13)
Issue	Root Cause	Professional Fix
nodemon: not found	Nodemon was not installed in the image.	Add RUN npm install -g nodemon to your Dockerfile.
Syncing too slowly	Watching the node_modules folder.	Ensure node_modules/ is in the ignore: section.
Port Conflict	Trying to run npm run dev on a port already taken.	Check that your EXPOSE and ports: in Compose match your app's internal port.
V. How to Understand it Perfectly

Think of Docker Compose Watch as the "Courier" and Nodemon as the "Manager."

    You save a file on your EliteBook.

    The Courier (Docker) sees the change and rushes the file into the container.

    The Manager (Nodemon) sees the new file arrive and tells the app to restart.

    Result: Your changes are live in your browser in milliseconds.

Final Commands for your Portfolio
Bash

# Start the stack with the live watcher
docker compose watch

# Check logs to see Nodemon starting
docker compose logs -f backend

Day 13: Dockerfile Best Practices (CMD vs. Scripts)
I. Technical Theory: The Layer of Abstraction

In Docker, the CMD is the "Final Instruction."

    Using ["node", "index.js"]: This is direct. It is best for Production because it is lightweight and starts the process immediately. However, it is "static"—it won't restart if you change your code.

    Using ["npm", "run", "dev"]: This is abstracted. It tells Docker to look at your package.json and run the dev script. Since your dev script uses nodemon, this is the standard for Development.

II. Deep Dive: Why "npm run dev" is better for you now

Since your package.json defines "main": "index.js", nodemon already knows to watch that file.

    By using npm run dev, you keep your Dockerfile clean.

    If you ever decide to change your main file from index.js to server.js, you only have to change it in one place (package.json) instead of updating every Dockerfile and Compose file in your project.

III. Professional Hands-on: The Final Dockerfile

Here is your optimized, professional-grade Dockerfile for your backend:
Dockerfile

# 1. Use a specific, lightweight base image
FROM node:18-alpine

# 2. Set the working directory
WORKDIR /app

# 3. Copy only package files first to leverage Docker cache
COPY package*.json ./

# 4. Install dependencies AND the watcher (nodemon)
RUN npm install && npm install -g nodemon

# 5. Copy the rest of the application code
COPY . .

# 6. Document the port the app runs on
EXPOSE 3001

# 7. Start the app via the npm script for flexibility
CMD ["npm", "run", "dev"]

IV. Troubleshooting Log (Day 13 Final)
Decision	Professional Reason	Impact
Use npm run dev	Allows nodemon to handle the process lifecycle.	Enables Hot Reloading.
Keep index.js out of CMD	Keeps the Dockerfile "generic" and reusable.	Easier maintenance.
Install nodemon globally	Ensures the binary is in the container's $PATH.	Prevents "command not found" errors.
V. How to Understand it Perfectly

Think of the Dockerfile as a Robot's Operating Manual:

    If you tell the robot: ["node", "index.js"], you are saying: "Pick up the blue box and stay still."

    If you tell the robot: ["npm", "run", "dev"], you are saying: "Read your manual (package.json) and follow the 'dev' instructions."

    Because the manual says to use nodemon, the robot now knows to: "Pick up the blue box, and if it turns red, put it down and pick up a new blue one."

Day 13: Compose for Development — Final Mastery
I. Technical Theory: The Feedback Loop

In professional software engineering, the Inner Loop is the time it takes for a developer to see the result of a code change. By enabling Docker Compose Watch, you have reduced your Inner Loop from minutes (build/stop/run) to milliseconds (sync/reload).
II. Deep Dive: Decoding the Output

When you see Syncing service "backend" after 1 changes were detected, three things just happened behind the scenes:

    File Watcher: Docker Compose detected a file save on your host OS.

    Differential Sync: Instead of rebuilding the whole image, Docker only pushed the specific file you changed into the /app directory.

    Process Trigger: Inside the container, Nodemon (which you set up in your Dockerfile) noticed the new file and restarted the Node.js process automatically.

III. Professional Hands-on: Summary of the Integration
Component	Role in your Project	Proof of Success
package.json	Defines the "Manual" with the dev script.	Your JSON is now valid and nested.
Dockerfile	Installs the "Manager" (nodemon).	The container stayed alive during the sync.
docker-compose.yml	Defines the "Courier" (develop: watch).	You see "Syncing service..." in your terminal.
IV. Troubleshooting Log (Verification Edition)
Observation	DevOps Insight	Action
"Syncing..." appears	The Watcher is working.	Check docker compose logs -f to see the app output.
"Syncing..." but no app change	The file synced, but the app didn't restart.	Ensure your Dockerfile CMD is exactly ["npm", "run", "dev"].
High CPU usage	Watching too many files (e.g., node_modules).	Verify your ignore: list in the develop section of the YAML.
V. How to Understand it Perfectly

You have now reached the "Pro Developer Experience" (DX) level.

    Day 11 was about the Past (saving data so it's there when you return).

    Day 12 was about the Rules (keeping secrets safe).

    Day 13 is about the Present (making changes live, right now).

VI. Compiled Final Notes for your Portfolio

    "I have optimized the development workflow for a three-tier architecture by implementing Docker Compose Watch. This setup utilizes a hybrid of bind-mount syncing and container-side process monitoring (Nodemon) to achieve instantaneous hot-reloading, significantly reducing development overhead while maintaining environmental parity."