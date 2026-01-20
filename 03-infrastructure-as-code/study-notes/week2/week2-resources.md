# Week 2: Terraform Modules & Advanced Workflow - Daily Resources

## 📅 **Week Overview**

**Focus:** Master Terraform modules, write first configurations, deploy to AWS  
**Duration:** 7 days  
**Success Metric:** Deploy VPC Infrastucture using Terraform

---

## 📘 **Day 1: Introduction to Infrastructure as Code**

### **🎯 Learning Objectives**

- Understand what Infrastructure as Code (IaC) is
- Learn why Terraform is popular
- Install and configure Terraform
- Write your first Terraform configuration

### **📚 Morning Resources (6:00-6:30 AM)**

#### **Video Tutorial (15 mins):**

- [What is Terraform?](https://www.youtube.com/watch?v=SLB_c_ayRMo) (first 15 minutes)
- **Key Takeaways:** 
  - IaC vs manual infrastructure
  - Terraform's declarative approach
  - Benefits: version control, collaboration, documentation

#### **Reading Material (10 mins):**

- [Terraform Introduction](https://developer.hashicorp.com/terraform/intro)
- **Focus on:**
  - How Terraform works
  - Write -> Plan -> Apply workflow
  - State management importance

#### **Concept Review (5 mins):**

- IaC = Infrastructure as Code
- HCL = HashiCorp Configuration Language
- Provider = Plugin that interacts with APIs (AWS, Azure, etc.)
- Resource = Infrastructure components (EC2, S3, etc.)

### **💻 Evening Practice (6:30-8:00 PM)**

#### **Step 1: Install Terraform (15 mins)**

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Terraform
sudo apt update
sudo apt install terraform

# Verify installation
terraform version