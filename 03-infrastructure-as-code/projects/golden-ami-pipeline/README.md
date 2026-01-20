Golden AMI Pipeline: Automated Image Factory

📌 Project Overview

This project automates the creation of "Golden AMIs" (Amazon Machine Images) using HashiCorp Packer and Terraform. A Golden AMI is a pre-configured, hardened image that contains security patches, monitoring agents, and standard configurations, ensuring consistency across a DevOps environment.
Key Features:

    Infrastructure as Code: Uses HCL (HashiCorp Configuration Language) for both image building and infrastructure.

    Automated Provisioning: Uses Shell scripts to install updates, AWS CLI, and CloudWatch agents.

    Version Control: Full pipeline configuration stored in GitHub for auditability.

    Validation: Automated triggers to ensure images are built only when configurations change.

🏗 Architecture

    Packer launches a temporary EC2 instance in AWS.

    Provisioners (Bash scripts) execute to harden the OS and install software.

    AWS creates an AMI from the running instance.

    Terraform (Optional) references the new AMI ID to deploy a scaling group.

🚀 How to Run
1. Initialize Packer
Bash

packer init .

2. Build the Image
Bash

packer build .

📸 Evidence of Completion

    Note to User: This is where you use your new shot command! Replace the placeholders below with your actual screenshots.

Build Success

Insert screenshot here showing the "Build 'amazon-ebs.ubuntu' finished" message.
AWS Console Verification

Insert screenshot of the AWS Console showing your new AMI in the "Available" state.
🛠 Lessons Learned & Troubleshooting

    Network Debugging: Encountered and resolved DNS resolution issues (archive.ubuntu.com) during the build phase by updating resolv.conf.

    Environment Management: Configured custom Linux aliases (shot) to streamline the documentation and auditing process.

    State Management: Learned the importance of modularizing Packer templates for different environments (Dev vs. Prod).

📂 Repository Structure