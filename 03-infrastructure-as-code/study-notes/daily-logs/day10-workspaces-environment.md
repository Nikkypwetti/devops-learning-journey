# Day 10: [Terraform Workspaces & Environments]

What I Learned

    Concept 1:

        Understanding Workspaces

        Workspaces allow you to manage multiple states for the same configuration. By default, Terraform uses a workspace named default. Creating new workspaces like dev or prod isolates your infrastructure state without needing to copy your code.

    Concept 2:

        Environment Isolation

        Using workspaces is one way to manage "Environments." It provides a mechanism to use the same configuration files to deploy separate instances of infrastructure (e.g., a dev instance and a prod instance) while keeping their state files separate.

    Concept 3:

        Referencing the Current Workspace

        You can use the ${terraform.workspace} interpolation sequence to change resource names or configurations dynamically. For example, tagging a resource with the name of the active workspace helps identify which environment it belongs to.

    Concept 4:

        Local vs. Remote State in Workspaces

        For local state, Terraform stores workspace data in a directory called terraform.tfstate.d. For remote backends (like S3 or Terraform Cloud), workspaces are handled server-side, allowing teams to collaborate on different environments safely.

    Concept 5:

        Workspaces vs. Directory Separation

        While workspaces are great for keeping code DRY (Don't Repeat Yourself), they share the same backend configuration. For environments that require completely different access controls or backends, separating environments into different directories/folders is often preferred.

    Concept 6:

        Safe Transitions

        Before running an apply, always verify your current context. Terraform doesn't provide a persistent visual indicator of the active workspace in the terminal, so using workspace show is a critical safety step to avoid deploying dev changes to production.

Code Practice
Terraform

# main.tf
# Using the workspace name to dynamically choose an instance type
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  
  # Logic: If workspace is 'prod', use t2.large; otherwise, use t2.micro
  instance_type = terraform.workspace == "prod" ? "t2.large" : "t2.micro"

  tags = {
    Name        = "web-server-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

Commands Used
Bash

# List all available workspaces
terraform workspace list

# Create a new workspace named 'dev'
terraform workspace new dev

# Switch to the 'prod' workspace
terraform workspace select prod

# Show the current active workspace
terraform workspace show

# Delete a workspace (must not be the current one)
terraform workspace delete dev

Challenges

Problem: Accidental deployment risk because it's hard to tell which workspace is active just by looking at the files. Solution: Incorporated ${terraform.workspace} into resource tags and created a bash wrapper script to ensure the correct workspace is selected before running terraform apply.
Resources

Video Tutorial
Video: [https://www.youtube.com/watch?v=u3wxXw0qGTY](https://www.youtube.com/watch?v=u3wxXw0qGTY) (10 mins)

    Video Notes: Workspaces manage multiple state files within same directory. Commands: terraform workspace list, new, select, delete. Different workspaces can have different variable values. Not recommended for full environment separation.

Documentation
Reading: [https://developer.hashicorp.com/terraform/language/state/workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)

    Reading Summary: Workspaces isolate state files. Default workspace is "default". Each workspace has separate state data. Use terraform.workspace in configurations. Workspace names in state file paths. Alternative: directory-based environments.

    Practice Completed: Created dev, staging, prod workspaces. Used terraform.workspace to conditionally set instance sizes. Directory structure: environments/dev/main.tf, environments/prod/main.tf.

Tomorrow's Plan

Topic 1: Remote State Management
