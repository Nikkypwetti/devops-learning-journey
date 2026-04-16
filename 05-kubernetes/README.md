# 🚢 Month 5: Kubernetes - Container Orchestration

## 🎯 **Month Overview**

**Duration:** 4 Weeks (28 days)  
**Focus Areas:** Kubernetes fundamentals, Pods, Deployments, Services, ConfigMaps, Secrets, Ingress  
**Target Skills:** Deploy, scale, and manage containerized applications on Kubernetes clusters

## 📊 **Learning Objectives**

By the end of this month, you will be able to:

- ✅ Understand Kubernetes architecture and core components
- ✅ Deploy applications using Pods and Deployments
- ✅ Expose applications using Services (ClusterIP, NodePort, LoadBalancer)
- ✅ Manage configuration with ConfigMaps and Secrets
- ✅ Implement Ingress for HTTP routing
- ✅ Perform rolling updates and rollbacks
- ✅ Use kubectl commands effectively
- ✅ Deploy real applications to Minikube

## 📅 **Weekly Breakdown**

### **Week 1: Kubernetes Fundamentals**

**Focus:** Architecture, core components, kubectl basics

- Day 1-2: Kubernetes introduction and architecture
- Day 3-4: Installing Minikube and kubectl
- Day 5-6: Pods and Deployments
- Day 7: Project - Hello Minikube

### **Week 2: Networking & Configuration**

**Focus:** Services, ConfigMaps, Secrets, Ingress

- Day 8-9: Services (ClusterIP, NodePort, LoadBalancer)
- Day 10-11: ConfigMaps for configuration
- Day 12-13: Secrets for sensitive data
- Day 14: Project - Guestbook app

### **Week 3: Advanced Workloads**

**Focus:** StatefulSets, Jobs, DaemonSets, persistent storage

- Day 15-16: Volumes and PersistentVolumes
- Day 17-18: StatefulSets for stateful apps
- Day 19-20: Jobs and CronJobs
- Day 21: Project - Voting application

### **Week 4: Production Ready**

**Focus:** Ingress, Helm, monitoring, production best practices

- Day 22-23: Ingress controllers and routing
- Day 24-25: Helm package manager
- Day 26-27: Monitoring with Dashboard
- Day 28: Final project - Three-tier app

## 🛠️ **Tools & Technologies**

### **Primary Tools:**

- **Minikube** - Local Kubernetes cluster
- **kubectl** - Kubernetes CLI
- **Docker** - Container runtime
- **Helm** - Package manager

### **Practice Environments:**

1. **Local:** Minikube, kubectl
2. **Cloud:** Play with Kubernetes (free), Katacoda
3. **Interactive:** Kubernetes Playground [citation:3]

## 📚 **Core Learning Resources**

### **Primary Video Course:**

1. ✅ **[Kubernetes Tutorial for Beginners - TechWorld with Nana](https://www.youtube.com/watch?v=X48VuDVv0do)** (4 hours) - Complete course [citation:9]

### **Official Documentation:**

2. **[Kubernetes Documentation](https://kubernetes.io/docs/)** - Official docs [citation:2]
3. **[Kubernetes Basics Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)** - Interactive tutorial [citation:4]
4. **[Hello Minikube Tutorial](https://kubernetes.io/docs/tutorials/hello-minikube/)** - First app on Minikube [citation:4]

### **Additional Video Resources:**

5. **[Complete Application Deployment using Kubernetes Components](https://www.youtube.com/watch?v=-kEw3FZw-44)** - TechWorld with Nana (hands-on project) [citation:5]

### **Practice Platforms:**

6. **[Introduction to Kubernetes Playground](https://platform.qa.com/lab/introduction-kubernetes-playground/)** - QA platform (free, up to 4 hours) [citation:3]
7. **[Kubernetes Monitoring Playground](https://platform.qa.com/lab/kubernetes-monitoring-playground-kubernetes-dashboard-prometheus-grafana/)** - Advanced playground [citation:7]

### **Interactive Tutorials:**

8. **[Kubernetes Basics Interactive Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)** - Official interactive tutorial [citation:6]

---

## 📁 Week 1: Detailed Daily Resources

**File:** `05-kubernetes/study-notes/week1/week1-guide.md`

```markdown
# Week 1: Kubernetes Fundamentals - Daily Resources

## 📅 **Week Overview**
**Focus:** Master Kubernetes basics, architecture, and first deployments  
**Duration:** 7 days  
**Success Metric:** Deploy first app on Minikube

---

## 📘 **Day 1: Introduction to Kubernetes**

### **🎯 Learning Objectives**
- Understand what Kubernetes is and why it's needed
- Learn Kubernetes architecture and core components
- Understand the problem Kubernetes solves

### **📚 Morning Resources (6:00-7:00 AM)**
#### **Video Tutorial (30 mins):**
- **[Kubernetes Tutorial for Beginners](https://www.youtube.com/watch?v=X48VuDVv0do)** - TechWorld with Nana
  - Watch from start through "Kubernetes Architecture" (around 35 minutes) [citation:1][citation:9]
  - **Key topics covered:**
    - What is Kubernetes? (container orchestration)
    - Problems it solves (scaling, failover, deployment)
    - Kubernetes vs Docker Swarm

#### **Reading Material (15 mins):**
- [What is Kubernetes?](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) - Official docs
- **Focus on:**
  - Container orchestration explained
  - Benefits: automated rollouts, scaling, self-healing

#### **Concept Review (15 mins):**
- **Container Orchestration**: Automating deployment, scaling, and management of containers
- **Kubernetes**: Greek for "helmsman" or "pilot"
- **Cluster**: Set of machines (nodes) running Kubernetes
- **Control Plane**: Manages the cluster (API server, scheduler, controller manager, etcd)
- **Worker Nodes**: Run actual application containers

### **💻 Evening Practice (6:30-8:00 PM)**
#### **Step 1: Install Minikube and kubectl (45 mins)**

**For Ubuntu/Debian:**
```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version

# Start Minikube cluster
minikube start --driver=docker
# This may take a few minutes to download the Kubernetes components

For macOS:
bash

# Install kubectl
brew install kubectl
kubectl version --client

# Install Minikube
brew install minikube
minikube start --driver=docker

For Windows (using Chocolatey):
powershell

# Install kubectl
choco install kubernetes-cli

# Install Minikube
choco install minikube
minikube start --driver=docker

Step 2: Verify Your Installation (15 mins)
bash

# Check cluster status
minikube status

# Expected output:
# minikube
# type: Control Plane
# host: Running
# kubelet: Running
# apiserver: Running
# kubeconfig: Configured

# Get cluster info
kubectl cluster-info

# List nodes in your cluster
kubectl get nodes

# Expected output:
# NAME       STATUS   ROLES           AGE   VERSION
# minikube   Ready    control-plane   2m    v1.28.0

# Get all pods in the system namespace
kubectl get pods -n kube-system

Step 3: Explore Kubernetes Dashboard (15 mins)
bash

# Open the Kubernetes dashboard
minikube dashboard

# This opens a browser window with the dashboard
# If you want just the URL (without opening browser):
minikube dashboard --url

# In another terminal, explore the dashboard:
# - View cluster nodes
# - Check running pods
# - Explore namespaces

Step 4: Basic kubectl Commands Practice (15 mins)
bash

# Check kubectl configuration
kubectl config view

# View current context
kubectl config current-context

# List all namespaces
kubectl get namespaces

# Get API resources
kubectl api-resources | head -20

# Get events in the cluster
kubectl get events

📝 Documentation (15 mins)

Answer in your learning log:

    What are the main components of the Kubernetes Control Plane?

    What is the role of kubelet on worker nodes?

    How does Minikube differ from a production Kubernetes cluster?

🔗 Additional Resources

    https://kubernetes.io/docs/concepts/overview/components/
    https://minikube.sigs.k8s.io/docs/
    https://kubernetes.io/docs/reference/kubectl/cheatsheet/
