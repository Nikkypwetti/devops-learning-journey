# 🏗️ Month 3: Infrastructure as Code (IaC)

## 🎯 **Month Overview**

**Duration:** 4 Weeks (28 days)  
**Focus Areas:** Terraform, Packer, Ansible, CI/CD Integration  
**Target Skills:** Infrastructure automation, configuration management, cloud provisioning

## 📊 **Learning Objectives**

By the end of this month, you will be able to:

- ✅ Write and deploy Terraform configurations
- ✅ Create reusable Terraform modules
- ✅ Build machine images with Packer
- ✅ Automate configuration with Ansible
- ✅ Implement CI/CD for infrastructure
- ✅ Manage state and collaborate on IaC
- ✅ Apply best practices for production

## 📅 **Weekly Breakdown**

### **Week 1: Terraform Fundamentals**

**Focus:** Terraform basics, syntax, and first deployments

- Day 1-2: Terraform introduction and installation
- Day 3-4: Terraform syntax and resources
- Day 5-6: Variables, outputs, and state management
- Day 7: First project - Static website on AWS

### **Week 2: Advanced Terraform**

**Focus:** Modules, workspaces, and best practices

- Day 8-9: Terraform modules and reusability
- Day 10-11: Workspaces and environments
- Day 12-13: Remote state and collaboration
- Day 14: Project - Multi-environment VPC

### **Week 3: Packer & Ansible**

**Focus:** Image building and configuration management

- Day 15-16: Packer fundamentals
- Day 17-18: Ansible basics
- Day 19-20: Combining Packer & Ansible
- Day 21: Project - Golden AMI pipeline

### **Week 4: CI/CD & Production Ready**

**Focus:** Automation, testing, and deployment

- Day 22-23: Terraform CI/CD with GitHub Actions
- Day 24-25: Testing and validation
- Day 26-27: Security and compliance
- Day 28: Final project - Three-tier application

## 🛠️ **Tools & Technologies**

### **Primary Tools:**

- **Terraform** - Infrastructure provisioning
- **Packer** - Machine image creation
- **Ansible** - Configuration management
- **GitHub Actions** - CI/CD automation
- **AWS Services** - Cloud platform

### **Supporting Tools:**

- **Visual Studio Code** with Terraform extension
- **Git** for version control
- **AWS CLI** for cloud operations
- **Docker** (optional) for containerization

### **Practice Environments:**

1. **Local:** Terraform CLI, VS Code
2. **Cloud:** AWS Free Tier
3. **Version Control:** GitHub
4. **CI/CD:** GitHub Actions (free tier)

## 📚 **Core Learning Resources**

### **Primary Documentation:**

1. **[Terraform Documentation](https://developer.hashicorp.com/terraform/docs)** - Official docs
2. **[Terraform Learn](https://learn.hashicorp.com/terraform)** - Interactive tutorials
3. **[Packer Documentation](https://developer.hashicorp.com/packer/docs)** - Official guides
4. **[Ansible Documentation](https://docs.ansible.com/)** - Complete reference

### **Video Tutorial Series:**

5. **[HashiCorp Terraform Tutorials](https://www.youtube.com/c/HashiCorp)** - Official videos
6. **[TechWorld with Nana - Terraform](https://www.youtube.com/watch?v=SLB_c_ayRMo)** - Complete course
7. **[FreeCodeCamp Terraform](https://www.youtube.com/watch?v=SLB_c_ayRMo)** - 2-hour tutorial
8. **[Andrew Brown - Terraform](https://www.youtube.com/c/ExamProChannel)** - Certification focused

### **Practice Platforms:**

9. **[Katacoda Terraform](https://www.katacoda.com/courses/terraform)** - Interactive labs
10. **[HashiCorp Learn](https://learn.hashicorp.com/)** - Hands-on tutorials
11. **[AWS Free Tier](https://aws.amazon.com/free/)** - For real deployments

## 🔗 **Week-by-Week Resource Guide**

### **Week 1 Resources (Days 1-7): Terraform Fundamentals**

Day 1: Introduction to IaC & Terraform
├── Video: <https://www.youtube.com/watch?v=SLB_c_ayRMo> (first 30 mins)
├── Reading: <https://learn.hashicorp.com/collections/terraform/aws-get-started>
└── Practice: Install Terraform, create first configuration

Day 2: Terraform Syntax & Resources
├── Video: <https://www.youtube.com/watch?v=l5k1ai_GBDE> (15 mins)
├── Reading: <https://developer.hashicorp.com/terraform/language>
└── Practice: Write HCL, create AWS resources

Day 3: Variables & Outputs
├── Video: <https://www.youtube.com/watch?v=7xngnjfIlK4> (12 mins)
├── Reading: <https://developer.hashicorp.com/terraform/language/values/variables>
└── Practice: Use variables.tf, outputs.tf

Day 4: State Management
├── Video: <https://www.youtube.com/watch?v=R2S1Zxpb6UE> (18 mins)
├── Reading: <https://developer.hashicorp.com/terraform/language/state>
└── Practice: Manage .tfstate, understand state importance

Day 5: Provisioners & Data Sources
├── Video: <https://www.youtube.com/watch?v=7YV0e2ZSRnY> (10 mins)
├── Reading: <https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax>
└── Practice: Use local-exec, remote-exec provisioners

Day 6: First Real Project
├── Tutorial: <https://learn.hashicorp.com/tutorials/terraform/aws-build>
├── Practice: Deploy static website on S3
└── Resources: AWS S3, CloudFront, Route53

Day 7: Review & Project Completion
├── Practice: Complete static website with Terraform
├── Documentation: Write README with architecture
└── GitHub: Push code to repository

### **Week 2 Resources (Days 8-14): Advanced Terraform**

Day 8: Terraform Modules
├── Video: https://www.youtube.com/watch?v=7xngnjfIlK4 (19 mins)
├── Reading: https://developer.hashicorp.com/terraform/language/modules
└── Practice: Create reusable modules

Day 9: Module Registry
├── Video: https://www.youtube.com/watch?v=S1ixM7k7Hvk (16 mins)
├── Reading: https://developer.hashicorp.com/terraform/registry
└── Practice: Use public modules, publish modules

Day 10: Workspaces & Environments
├── Video: https://www.youtube.com/watch?v=u3wxXw0qGTY (13 mins)
├── Reading: https://developer.hashicorp.com/terraform/language/state/workspaces
└── Practice: Create dev/stage/prod environments

Day 11: Remote State Management
├── Video: https://www.youtube.com/watch?v=o04xfWEouKM (15 mins)
├── Reading: https://developer.hashicorp.com/terraform/language/state/remote
└── Practice: Use S3 backend with DynamoDB locking

Day 12: Collaboration & Best Practices
├── Video: https://www.youtube.com/watch?v=ERk7MUf5r3c (20 mins)
├── Reading: https://www.terraform-best-practices.com/
└── Practice: Git workflow for Terraform

Day 13: VPC Project
├── Tutorial: https://developer.hashicorp.com/terraform/tutorials/aws/aws-vpc
├── Practice: Create complete VPC with modules
└── Resources: VPC, Subnets, IGW, NAT

Day 14: Project Review & Testing
├── Practice: Test VPC deployment
├── Validation: Use terraform validate, fmt
└── Documentation: Create deployment guide

### **Week 3 Resources (Days 15-21): Packer & Ansible**

Day 15: Packer Introduction
├── Video: <https://www.youtube.com/watch?v=6GIbJtG_9yk> (15 mins)
├── Reading: <https://learn.hashicorp.com/collections/packer/get-started>
└── Practice: Install Packer, create first template

Day 16: Packer Builders & Provisioners
├── Video: <https://www.youtube.com/watch?v=GB3pnzSIfyo> (12 mins)
├── Reading: <https://developer.hashicorp.com/packer/docs/templates>
└── Practice: Build AWS AMI with shell provisioner

Day 17: Ansible Fundamentals
├── Video: <https://www.youtube.com/watch?v=3b7DODiI-f8> (20 mins)
├── Reading: <https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html>
└── Practice: Install Ansible, write first playbook

Day 18: Ansible Playbooks & Roles
├── Video: <https://www.youtube.com/watch?v=ZAdJ7CdK7Rc> (18 mins)
├── Reading: <https://docs.ansible.com/ansible/latest/user_guide/playbooks.html>
└── Practice: Create reusable roles

Day 19: Packer + Ansible Integration
├── Video: <https://www.youtube.com/watch?v=QiTSe6r1gHw> (15 mins)
├── Reading: <https://developer.hashicorp.com/packer/plugins/provisioners/ansible>
└── Practice: Use Ansible provisioner in Packer

Day 20: Golden AMI Pipeline
├── Tutorial: <https://learn.hashicorp.com/tutorials/packer/aws-get-started>
├── Practice: Create automated AMI build pipeline
└── Resources: Packer, Ansible, AWS AMI

Day 21: Project Completion
├── Practice: Complete AMI pipeline
├── Automation: Add triggers and notifications
└── GitHub: Store configurations in repository

### **Week 4 Resources (Days 22-28): CI/CD & Production**

Day 22: Terraform CI/CD Basics
├── Video: <https://www.youtube.com/watch?v=sVO8gETDSUk> (16 mins)
├── Reading: <https://developer.hashicorp.com/terraform/cloud-docs/run>
└── Practice: Set up GitHub Actions for Terraform

Day 23: Advanced CI/CD Pipelines
├── Video: <https://www.youtube.com/watch?v=5T06tEw_yUo> (14 mins)
├── Reading: <https://github.com/features/actions>
└── Practice: Create multi-stage deployment pipeline

Day 24: Terraform Testing
├── Video: <https://www.youtube.com/watch?v=urMvGXfBDdc> (12 mins)
├── Reading: <https://developer.hashicorp.com/terraform/language/tests>
└── Practice: Write unit and integration tests

Day 25: Security & Compliance
├── Video: <https://www.youtube.com/watch?v=9L6C_6MhPSY> (18 mins)
├── Reading: <https://www.terraform-best-practices.com/security>
└── Practice: Use tfsec, checkov for security scanning

Day 26: Cost Management
├── Video: <https://www.youtube.com/watch?v=7IG_7zqFqYo >(10 mins)
├── Reading: <https://www.infracost.io/docs/>
└── Practice: Estimate costs with Infracost

Day 27: Three-Tier Application
├── Tutorial: <https://github.com/terraform-aws-modules/terraform-aws-atlantis>
├── Practice: Deploy complete three-tier app
└── Resources: ALB, ASG, RDS, ElasticCache

Day 28: Final Project & Review
├── Practice: Complete three-tier deployment
├── Documentation: Create full architecture documentation
└── Portfolio: Add to GitHub, prepare for interviews

## 📁 **Project Portfolio for Month 3**

### **Week 1 Project: Static Website on AWS**

- **Skills Demonstrated:** Basic Terraform, AWS S3, CloudFront
- **Technologies:** Terraform, AWS S3, CloudFront, ACM
- **GitHub:** `projects/static-website/`

### **Week 2 Project: Multi-Environment VPC**

- **Skills Demonstrated:** Terraform modules, workspaces, remote state
- **Technologies:** Terraform, AWS VPC, S3 backend
- **GitHub:** `projects/vpc-infrastructure/`

### **Week 3 Project: Golden AMI Pipeline**

- **Skills Demonstrated:** Packer, Ansible, automation
- **Technologies:** Packer, Ansible, AWS AMI
- **GitHub:** `projects/golden-ami/`

### **Week 4 Project: Three-Tier Application**

- **Skills Demonstrated:** Complete IaC pipeline, CI/CD, testing
- **Technologies:** Terraform, GitHub Actions, AWS services
- **GitHub:** `projects/three-tier-app/`

## 🎯 **Daily Learning Pattern**

### **Morning Session (6:00-6:30 AM):**

├── 10 mins: Watch concept video
├── 10 mins: Read documentation
└── 10 mins: Review yesterday's code

### **Evening Session (6:30-8:00 PM):**

├── 30 mins: Hands-on lab
├── 45 mins: Project work
└── 15 mins: Document progress

### **Weekly Review (Weekends):**

├── 2 hours: Complete weekly project
├── 1 hour: Review concepts
└── 1 hour: Update GitHub portfolio

## 📝 **Assessment Methods**

### **Daily Checkpoints:**

- [ ] Can explain today's concepts
- [ ] Successfully ran all commands
- [ ] Pushed code to GitHub
- [ ] Documented challenges and solutions

### **Weekly Goals:**

- [ ] Complete weekly project
- [ ] Pass practice quizzes
- [ ] Contribute to documentation
- [ ] Help others in community

### **Month-End Objectives:**

- [ ] All 4 projects completed
- [ ] Terraform Associate practice tests passed
- [ ] GitHub portfolio updated
- [ ] Can deploy production-ready infrastructure

## 🚨 **Common Pitfalls & Solutions**

### **Pitfall 1: State File Issues**

**Problem:** State file corruption or conflicts
**Solution:** Use remote state with locking, never edit .tfstate manually

### **Pitfall 2: Cost Overruns**

**Problem:** Unexpected AWS charges
**Solution:** Use cost estimation tools, set budgets, destroy resources after practice

### **Pitfall 3: Complex Configurations**

**Problem:** Overly complex Terraform code
**Solution:** Start simple, use modules, follow best practices

### **Pitfall 4: CI/CD Complexity**

**Problem:** Complex pipelines hard to debug
**Solution:** Start with simple pipeline, add complexity gradually

## 📈 **Success Metrics**

### **Technical Skills:**

- [ ] Write Terraform configurations from memory
- [ ] Debug common Terraform errors
- [ ] Create reusable modules
- [ ] Implement CI/CD pipelines
- [ ] Follow security best practices

### **Soft Skills:**

- [ ] Document infrastructure clearly
- [ ] Collaborate using Git workflow
- [ ] Explain IaC concepts to others
- [ ] Troubleshoot deployment issues

## 🚀 **Setup Instructions**

### **1. Install Required Tools:**

```bash
# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Packer
sudo apt install packer

# Install Ansible
sudo apt install ansible

# Install VS Code extensions
code --install-extension hashicorp.terraform
code --install-extension mohsen1.prettify-json
code --install-extension redhat.vscode-yaml