# Day 22: [Terraform CI/CD Basics]

## What I Learned

- Concept 1: Automation with CI/CD The primary goal of CI/CD for Terraform is to automate the provisioning process. Continuous Integration (CI) focuses on validating code (fmt, validate, plan), while Continuous Delivery (CD) automates the application of changes (apply) to infrastructure.

- Concept 2: The Terraform Workflow in Pipelines A standard pipeline follows four main steps:

    Init: Initialize the working directory and backend.

    Format/Validate: Check for syntax errors and style consistency.

    Plan: Generate an execution plan to see what will change.

    Apply: Deploy the changes (usually triggered by a merge to the main branch).

- Concept 3: GitHub Actions Components To automate Terraform with GitHub Actions, you use:

    Workflows: YAML files in .github/workflows/.

    Events: Triggers like pull_request (for planning) and push to main (for applying).

    Jobs/Steps: Sequential tasks run by the GitHub runner.

- Concept 4: State Management & Locking In a CI/CD environment, you must use a Remote Backend (like S3 or Terraform Cloud). This ensures the state file is accessible to the runner and allows for state locking to prevent multiple pipelines from modifying the same resources simultaneously.

- Concept 5: Secrets Management Sensitive information like AWS_ACCESS_KEY_ID or TERRAFORM_TOKEN should never be hardcoded. Use GitHub Actions Secrets to securely inject these credentials into the pipeline as environment variables.

- Concept 6: Pull Request Feedback A best practice is to have the pipeline post the output of terraform plan as a comment on the Pull Request. This allows reviewers to see exactly what infrastructure changes will occur before they approve the merge.
Code Practice

YAML
YAML

# .github/workflows/terraform.yml
name: "Terraform CI/CD"

on:
  push:
    branches: [ "main" ]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        if: github.event_name == 'pull_request'
        run: terraform plan

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve

## Commands Used

Bash
Bash

# Checks if your code follows canonical formatting
terraform fmt -check

# Validates the configuration for internal consistency
terraform validate

# Creates a plan and saves it to a file for the apply step
terraform plan -out=tfplan

# Applies the saved plan (used in automated environments)
terraform apply "tfplan"

## Challenges

    Problem: The GitHub runner failed because it couldn't find the state file.

    Solution: Configured an S3 backend in backend.tf. Local state doesn't persist across different GitHub Action runner instances, so remote state is mandatory.

## Resources

Video Tutorial

    New Video Link: GitHub Actions Tutorial - CI/CD Pipeline with Terraform

    Video Notes: This video covers setting up a full pipeline to provision AWS resources using GitHub Actions. It explains how to store secrets and trigger different actions based on PRs vs. Merges.

## Documentation

    Reading: Terraform Cloud - Run Workflow

    Reading Summary: Explains how Terraform manages runs, including the plan and apply phases. It details how GitHub integrations trigger these runs automatically upon code changes.

Practice Completed: Set up a GitHub repository with a basic Terraform configuration and a GitHub Actions workflow that runs terraform plan on every Pull Request.
Tomorrow's Plan

    Topic 1: Terraform Drift Detection and Remediation.