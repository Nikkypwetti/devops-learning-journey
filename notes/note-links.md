# Concept Connections

## AWS IAM → Terraform

- IAM roles can be created with Terraform
- Terraform needs IAM permissions to work
- Connect: [[../01-cloud-foundations/study-notes/iam/iam-basics.md]] → [[../03-infrastructure-as-code/study-notes/terraform-iam.md]]

## Docker → Kubernetes

- Docker containers run in Kubernetes pods
- Docker images stored in registries used by K8s
- Connect: [[../04-containerization/study-notes/docker-basics.md]] → [[../05-kubernetes/study-notes/pods-deployments.md]]

## Cross-Month Dependencies

- Month 1 (AWS) → Month 3 (Terraform): Provision AWS resources
- Month 4 (Docker) → Month 5 (K8s): Container orchestration
- Month 6 (CI/CD) → All: Automate everything