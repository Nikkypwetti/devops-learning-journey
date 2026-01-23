# Day 23: [Advanced CI/CD Pipelines]

## What I Learned

- Concept 1: Multi-Stage Pipelines Advanced CI/CD moves beyond simple "Build-and-Test" to multi-stage workflows. It involves logical separation between Build, Staging, and Production environments. Each stage acts as a gatekeeper, ensuring that code only progresses if it meets specific quality and security criteria.

- Concept 2: Workflow Dependencies (needs) In GitHub Actions, jobs run in parallel by default to save time. In advanced pipelines, we use the needs keyword to create a sequential dependency. For example, a "Deploy" job will only trigger if the "Build" and "Test" jobs complete successfully.

- Concept 3: Artifact Management To ensure consistency across stages, we "Build Once, Deploy Many." The Build stage generates an artifact (e.g., a .zip, .jar, or Docker image), which is uploaded using actions/upload-artifact. Subsequent stages download that exact same artifact using actions/download-artifact, preventing "it works on my machine" issues.

- Concept 4: Environments and Protection Rules GitHub Environments allow you to define specific targets like production. You can configure Environment Protection Rules, such as requiring a manual approval from a team lead or waiting for a specific time window before the deployment step executes.

- Concept 5: Secrets and Contexts Advanced pipelines utilize Environment Secrets. This allows the pipeline to use one set of database credentials for staging and a completely different, more secure set for production, without changing the underlying code.

- Concept 6: Deployment Strategies The pipeline can be configured for various deployment strategies:

    Blue-Green: Routing traffic between two identical environments.

    Canary: Releasing to a small subset of users first.

    Rolling: Updating instances one by one.

## Code Practice

GitHub Actions YAML
YAML

# .github/workflows/advanced-cicd.yml
name: Advanced Multi-Stage Pipeline

on:
  push:
    branches: [ main ]

jobs:
  # 1. Build Stage
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Application
        run: |
          mkdir dist
          echo "Compiled Application v1.0" > dist/app.txt
      
      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: production-ready-app
          path: dist/

  # 2. Staging Stage (Sequential Dependency)
  deploy_staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Download Artifact
        uses: actions/download-artifact@v4
        with:
          name: production-ready-app
          
      - name: Deploy to Staging
        run: echo "Deploying to Staging URL: https://staging.myapp.com"

  # 3. Production Stage (Requires Approval in GitHub Settings)
  deploy_production:
    needs: deploy_staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to Production
        run: echo "Final Deployment to https://myapp.com"

## Commands Used

Bash / Git
Bash

# Create a new directory for the workflow
mkdir -p .github/workflows

# Create the workflow file
touch .github/workflows/advanced-cicd.yml

# Push changes to trigger the multi-stage pipeline
git add .
git commit -m "Add multi-stage deployment pipeline"
git push origin main

# View live logs in GitHub Actions tab
# Check for "Environment" status in the Repository side-bar

## The Build Artifacts

The upload/download process ensures that the code doesn't change between testing and deployment.

    File: production-ready-app.zip

    Location: Found in the Summary tab of your GitHub Action run under "Artifacts."

    Why it's there: It allows you to audit exactly what was deployed to production and provides a rollback point if the deployment fails.

## Challenges

Problem: The "Production" job ran immediately without waiting for approval.

    Solution: I realized I hadn't configured the Environment in the GitHub Repository settings. I went to Settings > Environments > New Environment, named it production, and added myself as a Required Reviewer.

Problem: Artifact not found in the Deploy stage.

    Solution: Ensured that the name field in download-artifact matched the name field in upload-artifact exactly.

## Resources

Video Tutorial

    Video: Advanced CI/CD Pipelines (14 mins)

## Documentation

    Reading: GitHub Actions Official Features

## Practice: Creating a Multi-Stage Deployment Pipeline

To complete your practice task, follow this structure for your .github/workflows/deploy.yml file. This example demonstrates a Build stage followed by a Deploy stage that only runs if the build passes.
Example Workflow Code
YAML

name: Advanced Multi-Stage Pipeline

on:
  push:
    branches: [ main ]

jobs:
  # STAGE 1: Build and Test
  build_and_test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Environment
        run: echo "Compiling and running unit tests..."

      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: web-app-files
          path: ./dist  # Assuming your build output is here

  # STAGE 2: Deploy to Staging (Runs only if Build succeeds)
  deploy_staging:
    needs: build_and_test
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Download Artifact
        uses: actions/download-artifact@v4
        with:
          name: web-app-files

      - name: Deploy to Staging
        run: echo "Deploying to Staging Environment..."

  # STAGE 3: Deploy to Production (Requires manual approval if configured)
  deploy_production:
    needs: deploy_staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to Production
        run: echo "Deploying to Production Environment..."

## How to make the links work:

    Environment Secrets: Go to your GitHub Repository → Settings → Environments. Create "staging" and "production".

    Protection Rules: In the "production" environment, check Required reviewers. This forces the pipeline to "pause" and wait for you to click "Approve" before it goes live.

    Permissions: Ensure your GITHUB_TOKEN has contents: read and deployments: write permissions if you are interacting with third-party cloud providers.

## Tomorrow's Plan

    Topic 1: Pipeline Monitoring and Observability (Logging and Alerts)

    Topic 2: Introduction to Kubernetes Deployment Strategies via CI/CD