
---

## 📁 Week 4: Production Ready (Days 22-28)

**File:** `05-kubernetes/study-notes/week4/week4-guide.md`

```markdown
# Week 4: Production Ready - Daily Resources

## 📅 **Week Overview**
**Focus:** Ingress, Helm, monitoring, production best practices  
**Duration:** 7 days  
**Success Metric:** Deploy three-tier application with Helm and monitoring

---

## 📘 **Day 22: Ingress Controllers Deep Dive**

### **🎯 Learning Objectives**
- Understand Ingress Controller options
- Implement NGINX Ingress with TLS
- Use annotations for advanced routing

### **💻 Evening Practice (6:30-8:00 PM)**
#### **Lab: Advanced Ingress (60 mins)**

```bash
# Step 1: Install NGINX Ingress Controller
minikube addons enable ingress
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Step 2: Create multiple test services
kubectl create deployment apple --image=hashicorp/http-echo --port=5678 -- \
  -text="apple"
kubectl expose deployment apple --port=5678 --target-port=5678

kubectl create deployment banana --image=hashicorp/http-echo --port=5678 -- \
  -text="banana"
kubectl expose deployment banana --port=5678 --target-port=5678

# Step 3: Create Ingress with regex paths
cat > fruits-ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fruits-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  rules:
  - host: fruits.local
    http:
      paths:
      - path: /apple(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: apple
            port:
              number: 5678
      - path: /banana(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: banana
            port:
              number: 5678
EOF

kubectl apply -f fruits-ingress.yaml

# Step 4: Test Ingress
INGRESS_IP=$(minikube ip)
sudo sh -c "echo '$INGRESS_IP fruits.local' >> /etc/hosts"

curl fruits.local/apple
curl fruits.local/banana

# Step 5: Clean up
kubectl delete ingress fruits-ingress
kubectl delete service apple banana
kubectl delete deployment apple banana