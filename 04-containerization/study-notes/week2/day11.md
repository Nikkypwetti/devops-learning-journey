Day 11: Volumes & Data Management 
I. Technical Theory: The Persistence & Configuration Layer

In professional DevOps, we separate the Compute (the container) from the State (the data). Containers are ephemeral—they should be able to die and be replaced at any time. To achieve this, we use two distinct storage strategies.
1. The Hybrid Storage Model

    Named Volumes (mongo_data): These handle Dynamic State. They are high-performance, managed by Docker, and reside in a protected area of your host (/var/lib/docker/volumes/). This ensures your portfolio data survives even if you delete the container.

    Bind Mounts (mongod.conf): These handle Static Configuration. We "inject" a file from your project folder into the container. This allows us to harden the database security without building a custom image.

II. Final Professional Configuration
The Hardened db Service Structure
YAML

  db:
    image: mongo:latest
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${DB_USER}
      - MONGO_INITDB_ROOT_PASSWORD=${DB_PASSWORD}
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - mongo_data:/data/db             # Persistence Layer
      - ./mongod.conf:/etc/mongod.conf:ro # Security Layer (Read-Only)
    command: ["mongod", "--config", "/etc/mongod.conf"] # Explicit Config Enforcement
    networks:
      - backend-nw

The mongod.conf Security Manual
YAML

storage:
  dbPath: /data/db
net:
  bindIp: 0.0.0.0
  port: 27017
security:
  authorization: enabled # Enforces mandatory user authentication

III. The Troubleshooting Log (Nikky's DevOps Journey)
Issue Encountered	Root Cause	Professional Solution
cat: /etc/mongod.conf: No such file	Container not re-created after YAML update.	Ran docker compose up -d to refresh the "mount contract" between host and container.
Container exited (1)	YAML Syntax error in mongod.conf.	Analyzed docker compose logs db; found a YAMLException at line 6 (indentation error).
YAML Syntax Error	Hidden tabs or misaligned spaces.	Replaced all tabs with exactly 2 spaces. YAML is strictly space-sensitive.
Command find requires auth	Security hardening was active.	Proved that the mongod.conf successfully overrode default behavior to block unauthorized access.
Variable Scope Issues	Shell vs. Container variables.	Used sh -c inside the container to correctly access $MONGO_INITDB_ROOT_USERNAME.
IV. Verification & Mastery Workflow

To reach "Perfect Understanding," we performed the following validation sequence:

    Handshake Verification: docker compose exec backend nc -zv db 27017

        Result: Proved the network "pipe" is open between tiers.

    Configuration Audit: docker compose exec db ps aux | grep mongod

        Result: Confirmed the process is running with --config /etc/mongod.conf.

    The Destruction Test (The Gold Standard):

        Seed: Created a document item: 'Nikky-Portfolio-Success'.

        Kill: Ran docker compose down (destroyed all containers/networks).

        Resurrect: Ran docker compose up -d.

        Verify: Logged back in with credentials and found the data intact.

    CI Validation: Pushed to GitHub and received a Green Check, confirming the automation works.

V. How to Understand it Perfectly

    Logic vs. Data: Your code is in the Image. Your Rules are in the Bind Mount. Your Data is in the Volume. Keeping them separate is the mark of a Senior DevOps Engineer.

    Read-Only Security: By adding :ro to your bind mount, you ensured that even if a hacker takes over your database, they cannot modify the configuration file on your HP EliteBook.

    The Green Check: This is your proof of GitOps. You are now managing infrastructure through version control, which is the standard for modern tech roles in Japan and remote teams worldwide.