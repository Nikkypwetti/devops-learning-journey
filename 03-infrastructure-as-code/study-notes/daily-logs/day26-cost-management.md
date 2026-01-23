# Day 26: Cost Management (Infracost)

## What I Learned

- Concept 1: What is Infracost? Infracost is an open-source tool used by DevOps engineers to estimate cloud costs directly within Infrastructure as Code (Terraform). It provides a breakdown of how much your infrastructure will cost per month before you actually deploy it.

- Concept 2: "Shift Left" for Costs Traditionally, cost management happens after the bill arrives. Infracost allows you to "shift left" by making cost visibility part of the development process. This helps prevent "billing shock" and allows teams to make budget-conscious architectural decisions early.

- Concept 3: The Cloud Pricing API Infracost connects your local Terraform plan to a massive Cloud Pricing API (containing over 3 million prices for AWS, Azure, and GCP). It maps your resource definitions (like instance types or storage sizes) to real-world, up-to-date pricing data.

- Concept 4: Cost Breakdown vs. Diff - Breakdown: Provides a full list of every resource and its monthly cost. - Diff: Specifically shows the change in cost. If you upgrade a t2.micro to a t2.medium, the diff will show the exact dollar increase.

- Concept 5: Policy as Code (Infracost Guardrails) You can set up rules (guardrails) that automatically flag or block a Pull Request if the proposed infrastructure changes exceed a certain budget (e.g., "Do not allow any PR that increases monthly spend by more than $100").

- Concept 6: CI/CD Integration Infracost is most powerful when integrated into GitHub Actions or GitLab CI. It leaves a comment on your Pull Request showing the cost impact, so the reviewer can see the financial implications before clicking "Merge."
Code Practice
Terraform (Example Resource)
Terraform

# main.tf - A simple resource to estimate
resource "aws_instance" "web_app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.4xlarge" # An expensive instance to test Infracost

  root_block_device {
    volume_size = 100 # Cost breakdown will include EBS pricing
  }
}

## Commands Used

Bash
Bash

# Register and get your API Key (opens a browser)
infracost auth login

# Run a full breakdown of the costs in your current directory
infracost breakdown --path .

# Generate a cost breakdown and save it to a JSON file
infracost breakdown --path . --format json --out-file report.json

# Compare the current state vs. the new changes (The Diff)
infracost diff --path .

# Output the breakdown in a specific currency (e.g., EUR)
infracost breakdown --path . --currency EUR

## Challenges

Problem: API Key not found or "Unauthorized" error.

Solution: After running infracost auth login, ensure the .config/infracost/credentials.yml file is created. If on a remote server, use infracost configure set api_key <YOUR_KEY> manually.

Problem: Some resources showing "$0.00" or "Usage-based."

Solution: Certain resources like AWS Lambda or S3 data transfer depend on usage. I learned to use an infracost-usage.yml file to provide estimates for request counts and data transfer volumes to get an accurate price.

## Resources

## Video Tutorial

**Video:** [Infracost Quick Demo](https://www.youtube.com/watch?v=YyHZ_8OJotM) – Quick demo showing Infracost in action with Terraform.

## Documentation

**Reading:** [Infracost Getting Started Guide](https://www.infracost.io/docs) – The official guide for CLI installation and usage.

## Practice Lab

**Practice:** [Infracost GitHub Actions](https://github.com/marketplace/actions/infracost-actions) – Set up the GitHub Action so your costs appear automatically in your repository PRs.
## Practical Practice Steps (Try This Today)

Since you are building a GitHub portfolio, adding Infracost to your workflow is a great way to stand out.

    Install the CLI:
    Bash

## For Linux/WSL

curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

Get your API Key: Run infracost auth login to get your free key.

Run a Cost Breakdown: Navigate to one of your existing Terraform project folders and run:
Bash

infracost breakdown --path .

This will generate a table showing your estimated monthly spend for that project.

Compare Changes: If you change an instance type in your code, run:
Bash

infracost diff --path .

It will show you exactly how many dollars your monthly bill will increase or decrease based on that change.
- 
## Tomorrow's Plan

Topic 1: Terraform State Locking with S3 and DynamoDB. Topic 2: Managing Terraform workspaces for multiple environments (Dev/Prod).