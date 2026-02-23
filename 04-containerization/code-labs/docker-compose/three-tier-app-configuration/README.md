🚀 Three-Tier Portfolio Infrastructure: Secure & Persistent

This project demonstrates a production-grade deployment of a three-tier application using Docker Compose. It showcases advanced DevOps patterns including Network Segmentation, Data Persistence, Secret Management, and Developer Experience (DX) Optimization.
🏗️ Architecture Overview

The infrastructure is divided into three logical tiers, isolated via Docker bridge networks to ensure a "Zero Trust" security model:

    Frontend Tier (Nginx): Public-facing layer on frontend-nw. Handles client requests and reverse-proxies to the backend.

    Application Tier (Node.js): The bridge layer. Connected to both frontend-nw and backend-nw.

    Data Tier (MongoDB): Fully isolated on backend-nw. It is unreachable from the public frontend, preventing direct database attacks.

🛠️ Key Technical Features
1. Data Persistence & Hardening (Day 11)

We utilize a hybrid storage approach to ensure data integrity and system security:

    Named Volumes: mongo_data ensures database records survive container destruction and upgrades.

    Bind Mounts: Used to inject a hardened mongod.conf with authorization: enabled.

    Read-Only Security: Configuration files are mounted as :ro to prevent runtime tampering.

2. Environment & Secret Management (Day 12)

Following the Twelve-Factor App methodology, configuration is decoupled from code:

    Dynamic Interpolation: Uses .env files to inject credentials at runtime.

    Security: .env is git-ignored, and a .env.example template is provided for portability.

    Verification: Audited via docker compose config to ensure correct variable injection.

3. Developer Experience (DX) & Hot Reload (Day 13)

To optimize the "Inner Loop" of development, the stack features:

    Docker Compose Watch: Real-time file syncing between the host (HP EliteBook) and the container.

    Nodemon Integration: Automated process restarts inside the container upon code changes, enabling Hot Reload without rebuilding images.

🚀 Getting Started
Prerequisites

    Docker & Docker Compose (v2.22.0+)

    Linux/WSL2 Environment

Installation

    Clone the repository:
    Bash

git clone https://github.com/Nikky-techies/three-tier-app-configuration.git
cd three-tier-app-configuration

Setup Environment Variables:
Bash

cp .env.example .env
# Edit .env with your preferred credentials

Launch for Production:
Bash

docker compose up -d

Launch for Development (with Hot Reload):
Bash

    docker compose watch

🧪 Verification & Audit Commands
Goal	Command
Check Connectivity	docker compose exec backend nc -zv db 27017
Verify Auth	docker compose exec db mongosh --eval "db.testData.find()"
Audit Env	docker compose exec backend env
Check Logs	docker compose logs -f
📈 Engineering Evolution

This project evolved through a rigorous 6-day sprint:

    Days 8-10: Network segmentation and service discovery.

    Day 11: Volume persistence and configuration hardening.

    Day 12: Environment variable isolation and security auditing.

    Day 13: Hot-reload implementation via Compose Watch.

Current Status: CI/CD Passing ✅