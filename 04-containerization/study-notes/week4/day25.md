# 📘 Day 25: Docker Registry & Image Management - My Study Notes

🎯 What I'm Learning Today

How to store and manage Docker images using registries - both the public Docker Hub and my own private registry.
📝 Part 1: Understanding Registries (The Basics)
What is a Registry?

A registry is like GitHub for Docker images - it's where images are stored and from where they can be downloaded.

Two Types:

    Public Registry (Docker Hub) - default, everyone can see

    Private Registry - my own storage, only I can access

Key Terms I Need to Remember:

    Repository: A collection of related images (like "ubuntu" or "nginx")

    Tag: A specific version of an image (like "ubuntu:22.04" or "ubuntu:latest")

    Image Name Format: [registry-host]/[repository]:[tag]

⚠️ Part 2: IMPORTANT Discovery from My Reading

Wait, this is important! The Docker documentation I read revealed that:

    The Docker Registry project was donated to the Cloud Native Computing Foundation (CNCF) in 2019 and is now called "CNCF Distribution"

Why This Matters for My Learning:

    The old name "Docker Registry" might confuse me in older tutorials

    But good news: the commands are still the same!

    When I see registry:2 in commands, that's actually running CNCF Distribution

🛠️ Part 3: Hands-On - Running My Own Private Registry
Step 1: Start My Local Registry
bash

# This is like installing my own private Docker Hub on my computer
docker run -d -p 5000:5000 --name my-private-reg registry:2

Breaking Down This Command:
Part | What It Does
-d | Runs in background (detached) - like minimizing an app
-p 5000:5000 | Connects my computer's port 5000 to the registry's port 5000
--name my-private-reg | Gives my registry a friendly name
registry:2 | The image for the registry (version 2)
Step 2: Check If It's Working
bash

# This should return {} if everything is good
curl http://localhost:5000/v2/

If I see {}, my registry is alive! 🎉
🏷️ Part 4: The Tagging Dance (This is Crucial!)

Here's the thing I learned: Docker won't let me push to my private registry unless I tag the image correctly.
The Tag Format:
text

[registry-address]:[port]/[image-name]:[tag]

My Practice Workflow:

1. Get a test image:
bash

docker pull hello-world

2. Tag it for my local registry:
bash

# Before tagging: just "hello-world"
# After tagging: "localhost:5000/my-hello-world:v1.0"
docker tag hello-world localhost:5000/my-hello-world:v1.0

Think of it like:

    Original image = a letter addressed to "Mom"

    Tagged image = same letter, but now addressed to "123 Main St, Mom"

    Same content, different destination!

🔄 Part 5: Push & Pull - The Complete Workflow
Step 1: Push to My Registry
bash

docker push localhost:5000/my-hello-world:v1.0

This is like uploading a file to my private cloud storage
Step 2: Remove Local Copies (To Test Pulling)
bash

# Delete both the tagged and original images
docker rmi localhost:5000/my-hello-world:v1.0
docker rmi hello-world

Now my computer has no copy of hello-world
Step 3: Pull from My Registry
bash

docker pull localhost:5000/my-hello-world:v1.0

This downloads from my registry instead of Docker Hub
Step 4: Run It!
bash

docker run localhost:5000/my-hello-world:v1.0

It works! My private registry is functioning!
💡 Part 6: Important Tips I Discovered
⚠️ Security Note

The way I set it up above has NO SECURITY. In the real world:

    Must set up HTTPS (like a lock on my registry)

    Need usernames/passwords

    This is fine for learning though!

💾 Making Images Permanent (Volumes)

Right now, if I delete my registry container, I lose all images! Here's how to save them:
bash

# This saves images to my computer's hard drive
docker run -d -p 5000:5000 --name my-private-reg \
  -v /Users/myuser/docker-registry:/var/lib/registry \
  registry:2

The -v flag creates a "volume" - like a USB drive attached to the container
🔍 Browsing My Registry

The registry itself has NO visual interface - it's all command line. If I want to see my images nicely:

    I can install docker-registry-ui separately

    Or use curl commands to list images:
    bash

curl http://localhost:5000/v2/_catalog

📋 Part 7: My Quick Reference Card
Essential Commands I Must Remember:
Action | Command
Start registry | docker run -d -p 5000:5000 --name registry registry:2
Tag for local | docker tag SOURCE_IMAGE localhost:5000/NAME:TAG
Push | docker push localhost:5000/NAME:TAG
Pull | docker pull localhost:5000/NAME:TAG
List images in registry | curl http://localhost:5000/v2/_catalog
Stop registry | docker stop my-private-reg
Remove registry | docker rm my-private-reg
Common Mistakes I'll Avoid:

    ❌ Forgetting to tag before pushing

    ❌ Using https:// in address (just use localhost:5000)

    ❌ Not using port number in tag

    ❌ Expecting a web interface (it's API-only!)

🧠 Part 8: Why This Matters

Real-world use cases:

    Companies keep images private for security

    Faster pulls within company network

    No internet needed for deployments

    Can add security scanning and approvals

What I've accomplished today:
✅ Learned what registries are
✅ Understood the difference between public and private
✅ Ran my own registry
✅ Tagged images correctly
✅ Pushed and pulled from my registry
✅ Learned about CNCF Distribution (the modern name)
🔜 Part 9: What's Next / Practice Ideas

Tomorrow I should:

    Try with a real application image (like nginx)

    Experiment with volumes to persist images

    Try stopping and restarting my registry

    Learn about registry UI tools

Extra Challenge: Try setting up two different tags for the same image and practice pushing/pulling both!


## Note i jotte down while watching the video and reading the docs.

🗒️ Study Notes: Docker Registry & Image Management

Goal: Master how images move from a local machine to a shared "library" (Registry) and back.

1. The Big Picture: What is a Registry?

Think of a Registry as a Bookshelf (Library).

    Registry: The entire library (e.g., Docker Hub).

    Repository: A specific shelf for one book title (e.g., the nginx shelf).

    Image Tag: A specific edition/version of that book (e.g., v1.2 or latest).

Common Registries in DevOps:

    Public: Docker Hub (Default).

    Private/Enterprise: AWS ECR (Elastic Container Registry), Azure Container Registry (ACR), or Google Artifact Registry.

2. The Workflow (The "Push/Pull" Dance)

In the real world, you don't just "send" a file. You follow these 3 steps:
Step A: Tagging (Naming your child)

Docker won't know where to push an image unless the name includes the registry address.

    Command: docker tag <old-name> <registry-url>/<image-name>:<tag>

    Example: docker tag my-app:v1  nikky-devops.com/my-app:v1

    Why? The first part of the name (the URL) tells Docker the destination.

Step B: Login (The Keys)

You can’t walk into a private library and put books on the shelf without an ID.

    Command: docker login <registry-url>

    Pro Tip: This saves your credentials in ~/.docker/config.json. Be careful with this file!

Step C: Pushing/Pulling (The Action)

    Push: Uploading your built image to the registry.

        docker push nikky-devops.com/my-app:v1

    Pull: Downloading that image onto a production server.

        docker pull nikky-devops.com/my-app:v1

3. Setting up a "Private" Local Registry

This is the best way to practice without paying for cloud storage.

    Run the Registry Container:
    Bash

    docker run -d -p 5000:5000 --name my-registry registry:2

    Now you have a private registry running on localhost:5000.

    The "Local" Test:

        Take a random image: docker pull busybox

        Tag it for your local shelf: docker tag busybox localhost:5000/my-busybox

        Push it: docker push localhost:5000/my-busybox

4. Real-World DevOps Best Practices (The "Perfect" Way)

Feature | DevOps Rule | Why?
Versioning | NEVER use :latest in Prod. | It causes "mystery" deployments. Use Git SHAs or Semantic Versions (v1.0.1).
Security | Scan images during Push. | Tools like Docker Scout or Snyk check for vulnerabilities before the image reaches the shelf.
Storage | Use Lifecycle Policies. | Images take up massive space. Delete old "Dev" images automatically after 30 days.
Efficiency | Use Multi-stage builds. | Smaller images push and pull faster, saving bandwidth and time in CI/CD.

5. Troubleshooting Checklist

    "Permission Denied": Did you run docker login?

    "Image not found": Is the tag exactly the same? (v1 is not the same as V1).

    "Connection Refused": If using a local registry, is the container actually running? (docker ps).