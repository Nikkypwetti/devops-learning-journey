
---

## 📘 **Day 28: Month 5 Review & Certification Path**

### **🎯 Learning Objectives**
- Review all Month 5 concepts
- Plan certification path
- Prepare for next month

### **💻 Evening Practice (6:30-8:00 PM)**

```bash
# Step 1: Create final review document
cat > KUBERNETES_CHEATSHEET.md << 'EOF'
# Kubernetes Quick Reference

## Essential Commands
```bash
# Cluster info
kubectl cluster-info
kubectl get nodes
kubectl get namespaces

# Workloads
kubectl get pods -w
kubectl get deployments
kubectl get replicasets
kubectl get statefulsets
kubectl get daemonsets
kubectl get jobs
kubectl get cronjobs

# Networking
kubectl get services
kubectl get ingress
kubectl get endpoints

# Storage
kubectl get pv
kubectl get pvc
kubectl get storageclass

# Configuration
kubectl get configmap
kubectl get secret

# Troubleshooting
kubectl describe pod <pod>
kubectl logs <pod>
kubectl logs <pod> --previous
kubectl exec -it <pod> -- /bin/sh
kubectl port-forward <pod> 8080:80

# Scaling
kubectl scale deployment <name> --replicas=5
kubectl autoscale deployment <name> --cpu-percent=50 --min=3 --max=10

# Updates
kubectl set image deployment/<name> <container>=<new-image>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>

# Resources
kubectl top nodes
kubectl top pods