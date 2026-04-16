This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.

## 🏗️ Technical Architecture

This project implements a Distributed Microservices Architecture designed for high availability and real-time data processing. The system is orchestrated using Docker Swarm and integrated via a custom Nginx Reverse Proxy.

### 📡 The Data Pipeline

    Traffic Entry: A Next.js (Voting) and React (Results) frontend serve as the user interface. All traffic is routed through Nginx, which is configured to handle standard HTTP requests and specialized WebSocket (WS) handshakes for real-time updates.

    Ingestion: Votes are sent to a Python/Flask API, which acts as a lightweight producer, pushing vote data into a Redis message broker to decouple the frontend from database write speeds.

    Processing: A .NET/C# Worker service acts as the consumer, constantly monitoring Redis for new entries. Once a vote is pulled, the worker processes and persists it into a PostgreSQL database.

    Broadcast: The Node.js Result Service monitors the PostgreSQL state and uses Socket.io to broadcast live totals to all connected clients instantly.

## 🛠️ DevOps Implementation & Challenges

### 🔐 Advanced Secret Management

To follow production security standards, I implemented Docker Swarm Secrets. Database credentials are never hardcoded in environment variables. Instead, they are injected at runtime into the /run/secrets/ directory of the Worker and Database containers, ensuring a zero-trust configuration.

### 🔄 Real-Time Scaling & Handshaking

A major challenge was the Nginx WebSocket Upgrade. Standard proxy configurations drop WebSocket connections. I implemented a custom map block and "Upgrade/Connection" headers in the Nginx configuration to ensure stable, long-lived connections between the Result UI and the backend.

### 🏗️ Infrastructure as Code (IaC)

The entire stack is defined in a modular docker-compose.yml file, supporting:

    Dual Networks: frontend and backend networks to isolate database traffic from public-facing services.

    Persistent Volumes: Ensuring vote data survives container restarts or service updates.

    Health Checks: Configured to ensure services only receive traffic once they are fully initialized.

## 🚀 CI/CD Pipeline

The project utilizes GitHub Actions for a fully automated CI/CD lifecycle:

    Matrix Builds: Optimized builds for multiple services (Python, .NET, Node.js) simultaneously.

    Security Auditing: Integrated Trivy to scan every Docker image for CRITICAL vulnerabilities before pushing to Docker Hub.

    Automated Tagging: Implemented semantic versioning using Git SHAs for precise rollback capabilities.