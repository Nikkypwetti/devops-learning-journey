# 🏢 Multi-Account AWS IAM Strategy

## 📋 Project Overview

Design and implement a comprehensive IAM strategy for a fictional enterprise "TechCorp International" with multiple AWS accounts.

## 🎯 Business Scenario

TechCorp International is expanding to AWS with the following structure:
- **Management Account**: 111111111111 (Central governance)
- **Production Account**: 222222222222 (Live applications)
- **Development Account**: 333333333333 (Development environment)
- **Security Account**: 444444444444 (Central security logging)

## 📊 Architecture

![IAM Strategy Architecture](./architecture-diagrams/iam-strategy.png)

## 🛡️ Security Principles Implemented

- ✅ Least Privilege Access
- ✅ Separation of Duties
- ✅ Defense in Depth
- ✅ Centralized Identity Management
- ✅ Audit Trail Enabled

## 📁 Project Structure

multi-account-iam-strategy/
├── architecture-diagrams/ # Visual designs
├── iam-policies/ # JSON policy definitions
├── terraform/ # Infrastructure as Code
├── scripts/ # Automation & validation
├── docs/ # Detailed documentation
└── tests/ # Policy testing