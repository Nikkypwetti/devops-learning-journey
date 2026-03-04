# 📘 DAY 26 STUDY NOTES: CI/CD WITH DOCKER

My Personal Learning Journey
🎯 What I'm Learning Today

CI/CD + Docker + GitHub Actions = AUTOMATION MAGIC! ✨

Today I'm figuring out how to automatically build, test, and deploy my Docker containers whenever I push code to GitHub. No more manual building and pushing!

📝 SECTION 1: Let's Start with the Basics
🤔 What is CI/CD Anyway?

CI = Continuous Integration (automatically build + test my code)
CD = Continuous Delivery/Deployment (automatically ship it!)

Think of it like:
I push code → Computer takes over → My app gets updated

🏗️ GitHub Actions - My New Robot Assistant

┌─────────────────────────────────────┐
│  GitHub Actions = My Personal Builder │
│  - Watches my repository             │
│  - Runs tasks when I push code       │
│  - Reports back if something fails    │
└─────────────────────────────────────┘

🧩 SECTION 2: Understanding the Pieces (Like LEGO Blocks!)

The 4 Main Parts I Need to Know:

1️⃣ WORKFLOW 📄
   └── The master plan (YAML file)
   └── Lives in: .github/workflows/
   └── Example: "When I push to main, build my Docker image"

2️⃣ JOB 🔧
   └── A bunch of tasks to complete
   └── Example: "Build job" or "Test job"
   └── Jobs can run together or one after another

3️⃣ STEP 👣
   └── One single thing to do
   └── Example: "Run npm install" or "Build Docker image"

4️⃣ ACTION ⚡
   └── Reusable pre-made steps (saves me time!)
   └── Example: Docker's official actions

Visualizing How They Connect:

MY PUSH ──▶ WORKFLOW ──▶ JOB 1 ──▶ STEP 1 (Checkout code)
            (YAML)        │         ├─▶ STEP 2 (Login to Docker)
                          │         └─▶ STEP 3 (Build image)
                          ├─▶ JOB 2 ──▶ STEP 1 (Run tests)
                          └─▶ JOB 3 ──▶ STEP 1 (Deploy)

🐳 SECTION 3: Docker's Special Actions (My New Best Friends)

The Docker Toolbox for GitHub Actions
Action Name    What It Does    When I'll Use It
docker/login-action    Logs into Docker Hub/GHCR    Every time I need to push an image
docker/setup-buildx-action    Sets up advanced builder    For multi-platform builds
docker/setup-qemu-action    Enables building for ARM/Raspberry Pi    When building for different chips
docker/metadata-action    Creates smart tags automatically    Always! Saves me from naming headaches
docker/build-push-action    Actually builds + pushes my image    The main event!
docker/scout-action    Checks for security problems    Before deploying to production

💡 SECTION 4: My "AHA!" Moment - The Metadata Action
Why This is Genius:

Instead of me manually thinking of tags:

Without Metadata Action:
"Umm... I'll use 'latest' and... uh... 'v1.0' I guess?" 🤔

With Metadata Action (Automatic Magic!):

- On main branch → tags: "latest", "main"
- On version tag v1.2.3 → tags: "v1.2.3", "1.2.3", "1.2", "1"
- On pull request → tags: "pr-42"
- Always gets commit SHA → tags: "sha-a1b2c3"

🔨 SECTION 5: Let's Build Our First Workflow!
Step-by-Step: The Recipe for Success

📁 My Repository Structure:
my-cool-app/
├── .github/
│   └── workflows/
│       └── docker-build.yml    ← I'll create this!
├── Dockerfile
├── src/
└── package.json

My Workflow File (with explanations!):
yaml

# File: .github/workflows/docker-build.yml

# 📌 NAME: What should I call this workflow?
name: Build and Push My Docker Image

# 🎯 TRIGGER: When should this run?
on:
  push:
    branches: [ "main" ]        # When I push to main
  pull_request:
    branches: [ "main" ]        # When someone opens a PR

# 👷 JOBS: What work needs to be done?
jobs:
  # This is my main job - building the Docker image
  build-and-push:
    # The computer that will run this (GitHub gives me this for free!)
    runs-on: ubuntu-latest
    
    # 🔑 PERMISSIONS: What can this job do?
    permissions:
      contents: read            # Read my code
      packages: write            # Push to GitHub Packages

    # 📋 STEPS: The actual to-do list
    steps:
      # Step 1: Get my code from GitHub
      - name: 📥 Download my code
        uses: actions/checkout@v4

      # Step 2: Log into Docker Hub (using my secrets!)
      - name: 🔐 Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}
        # ⚠️ Note: I need to set these secrets in GitHub first!

      # Step 3: Set up the fancy builder
      - name: 🛠️ Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Step 4: Generate smart tags automatically
      - name: 🏷️ Generate tags
        id: meta                 # I'll refer to this later
        uses: docker/metadata-action@v5
        with:
          # My image name on Docker Hub
          images: myusername/myapp
          # The tags I want
          tags: |
            type=raw,value=latest,enable={{is_default_branch}}
            type=sha,format=short
            type=ref,event=pr

      # Step 5: Build and push the image!
      - name: 🏗️ Build and push
        uses: docker/build-push-action@v5
        with:
          context: .              # Build from current directory
          file: ./Dockerfile      # Use this Dockerfile
          push: ${{ github.event_name != 'pull_request' }}
          # ^ Only push if NOT a pull request
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          # ⚡ Speed up with caching!
          cache-from: type=gha
          cache-to: type=gha,mode=max

🔐 SECTION 6: SECRETS - Keeping My Passwords Safe!
How to Store Secrets (My Private Info):

NEVER do this: ❌
password: "mypassword123"  ← Anyone can see it!

ALWAYS do this: ✅
password: ${{ secrets.DOCKER_PASSWORD }}

Where to put them in GitHub:
Repository → Settings → Secrets and variables → Actions
     ↓
[New repository secret]
Name: DOCKER_USERNAME
Value: your-dockerhub-username
     ↓
[New repository secret]
Name: DOCKER_TOKEN
Value: your-docker-access-token

🚀 SECTION 7: Practice Exercise - My Turn!
Today's Mission:

🎯 GOAL: Create my own CI/CD pipeline

STEP 1: Create a simple app
   └── Any app with a Dockerfile works!

STEP 2: Add the workflow file
   └── Copy the example above
   └── Change "myusername/myapp" to my real Docker Hub username

STEP 3: Set up secrets
   └── Add DOCKER_USERNAME
   └── Add DOCKER_PASSWORD (or token)

STEP 4: Push to GitHub
   └── git add .
   └── git commit -m "Add CI/CD pipeline"
   └── git push origin main

STEP 5: Watch the magic! 🍿
   └── Go to GitHub → Actions tab
   └── See my workflow running

✅ SECTION 8: Quick Reference - What I Learned Today
The Mental Model:

┌─────────────────────────────────────────┐
│           I PUSH MY CODE                 │
│                    ↓                      │
│    GitHub Actions detects the push        │
│                    ↓                      │
│    Reads my workflow (.yml file)          │
│                    ↓                      │
│    Logs into Docker Hub (using secrets)   │
│                    ↓                      │
│    Builds my Docker image                  │
│                    ↓                      │
│    Tags it automatically                   │
│                    ↓                      │
│    Pushes it to Docker Hub                 │
│                    ↓                      │
│    My app is updated! 🎉                   │
└─────────────────────────────────────────┘

Key Commands/Actions I'll Use Most:
What I Want	Action I Use
Log into Docker    docker/login-action
Build my image    docker/build-push-action
Generate tags    docker/metadata-action
Multi-platform build    setup-buildx-action + setup-qemu-action
Security scan    docker/scout-action

💭 My Personal Takeaways:

✨ The beauty of this:
Once set up, I never have to manually:

- Build images on my laptop
- Remember complex docker commands
- Worry about forgetting to push an update
- Deal with "it works on my machine" problems

The computer does it all for me! 🤖

📚 Resources I Used Today:

    📺 Video: TechWorld with Nana (great visuals!)

    📄 Docs: https://docs.docker.com/ci-cd/github-actions

    💻 Practice: My own GitHub repo with Actions

🎯 Next Steps:

Tomorrow I'll learn about:
└── Multi-container applications
└── Docker Compose in CI/CD
└── Deployment to cloud servers

## Note i jotte down while watching the video and reading the docs.

Day 26: CI/CD with Docker (Study Notes)

1. The Big Picture: Why am I doing this?

In a professional setting, we don't want to manually run docker build and docker push every time we change code. It’s slow and risky.

    Goal: Create a "hands-off" pipeline.

    The Flow: Code Change → GitHub → Auto Build Image → Auto Push to Registry (Docker Hub).

2. Key Vocabulary (The "Blocks")

I need to keep these four terms straight:

    Workflow: The entire process (the .yml file).

    Events: The "Trigger" (e.g., git push).

    Jobs: The "Workstations" (e.g., one job for testing, one for building).

    Actions: The "Pre-made Tools" (reusable code like checkout or login).

3. Setting Up the Environment (The "Secret" Step)

Before writing code, I have to handle security. Never put passwords in the YAML file.

    Go to GitHub Repo > Settings > Secrets.

    Store my Docker Hub Username as DOCKERHUB_USERNAME.

    Store my Docker Hub Personal Access Token (PAT) as DOCKERHUB_TOKEN.

4. Anatomy of a Professional Workflow File

I’ll place this file in .github/workflows/docker-ci.yml.

YAML
name: Build and Ship Docker

# 1. When should this run?
on:
  push:
    branches: [ "main" ]  # Only run when code hits the main branch

# 2. What needs to happen?
jobs:
  deploy:
    runs-on: ubuntu-latest  # This is a fresh server GitHub gives me for free
    
    steps:
      # Step A: Get my code onto the runner
      - name: Checkout Code
        uses: actions/checkout@v4

      # Step B: Log into Docker Hub (using my secrets)
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Step C: Build the image and push it
      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .       # Where is the Dockerfile? (Current directory)
          push: true       # Yes, send it to Docker Hub
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/my-app:latest

5. Professional "Pro-Tips" I Noticed

    BuildKit is King: Professional pipelines use docker/setup-buildx-action. It makes builds much faster by caching "layers" of the image.

    Runner Environment: The ubuntu-latest runner already has Docker installed. I don't need to install it manually in the script.

    Parallelism: If I have a test job and a build job, they run at the same time unless I tell the build job: needs: test.

6. My Practice Checklist

    [ ] Created a simple Dockerfile for my app.

    [ ] Added Docker Hub credentials to GitHub Secrets.

    [ ] Created the .github/workflows folder structure.

    [ ] Pushed code and watched the "Actions" tab turn green.

    [ ] Verified the new image appeared in my Docker Hub repository.

Here is how I’d add the "Testing" phase to my study notes, making sure it’s clear how the jobs depend on each other.

7. Adding the "Test" Job (The Gatekeeper)

I need to separate Testing from Building. I’ll create two distinct jobs. If "Test" fails, the "Build" job won't even start.
The "Needs" Keyword

This is the most important concept here. By default, GitHub Actions runs jobs in parallel. To make them sequential, I use needs: [job_name].
8. Updated Study Workflow (.yml)
YAML

name: Professional CI/CD with Testing

on:
  push:
    branches: [ "main" ]

jobs:
# --- JOB 1: TESTING ---
  test-logic:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Node.js  # Or Python/Go depending on my app
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: npm install

      - name: Run Unit Tests
        run: npm test  # If this command fails, the whole pipeline stops!

# --- JOB 2: DOCKER BUILD (Only runs if Job 1 passes) ---
  build-and-ship:
    runs-on: ubuntu-latest
    needs: test-logic  # <--- THIS IS THE MAGIC LINK
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/my-app:latest

9. Key Insights from this Setup

    Separation of Concerns: Job 1 is about the Code (Internal). Job 2 is about the Container (External).

    Fresh Environments: Each job starts with a brand-new, clean Ubuntu server. That’s why I have to run actions/checkout@v4 in both jobs. They don't automatically share files!

    Artifacts (Deep Dive): If I wanted to pass the actual built code from Job 1 to Job 2 (to avoid re-downloading things), I would use actions/upload-artifact and actions/download-artifact.

10. Troubleshooting My Notes

    What if the test fails? The "Actions" tab will show a Red X on test-logic, and build-and-ship will show a gray "skipped" status. No broken image gets pushed to Docker Hub. Success!

    Speed Tip: Using the official docker/setup-buildx-action before the build step will help with caching layers, making the second job run much faster in the long run.

Here is how I’m documenting the notification setup in my notes.
11. Adding Notifications (The "Alert" Phase)

Now, I want a message sent to my Discord/Slack channel as soon as the pipeline finishes. This is the "CD" (Continuous Delivery) part of the feedback loop.
Why do this?

    I don't have to refresh the browser.

    The whole team knows immediately if a build fails.

    It creates a log of deployments in our chat history.

12. The "Full Picture" Workflow Note

I'll add a final job called notify that runs after the build is done.
YAML

# ... (Previous jobs: test-logic and build-and-ship)

  notify:
    runs-on: ubuntu-latest
    needs: build-and-ship # Only notify after the build job finishes
    if: always()          # IMPORTANT: Run this even if the build fails!
    
    steps:
      - name: Discord Notification
        uses: sarisia/actions-status-discord@v1
        with:
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          status: ${{ job.status }} # Tells me if it "Succeeded" or "Failed"
          content: "Deployment update for My-App"
          title: "CI/CD Pipeline Result"

13. Critical Notes on the if: always() Logic

This is a "gotcha" I need to remember:

    By default, if build-and-ship fails, GitHub stops the whole workflow.

    But I want a notification if it fails!

    if: always() forces this job to run regardless of what happened in the previous steps.

14. Final Study Summary (The DevOps Checklist)

By the end of Day 26, my professional pipeline does this:

    Triggers on code push.

    Tests the raw code (Unit Tests).

    Builds the Docker Image (only if tests pass).

    Pushes to Docker Hub (Image Registry).

    Notifies the team via Discord/Slack (Feedback Loop).

15. Practical Setup for My Notes

    Discord Setup: Go to Discord Channel Settings > Integrations > Webhooks > Copy URL.

    GitHub Setup: Save that URL as a secret named DISCORD_WEBHOOK.