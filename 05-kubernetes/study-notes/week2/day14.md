
---

## 📘 **Day 14: Week 2 Review & Project Completion**

### **🎯 Learning Objectives**
- Review Week 2 concepts
- Complete Guestbook application
- Troubleshoot common issues

### **💻 Evening Practice (6:30-8:00 PM)**

```bash
# Step 1: Test application functionality
FRONTEND_URL=$(minikube service frontend --url)
echo "Testing Guestbook App at $FRONTEND_URL"

# Add messages
curl -X POST "$FRONTEND_URL" -d "message=First message"
curl -X POST "$FRONTEND_URL" -d "message=Second message"
curl -X POST "$FRONTEND_URL" -d "message=Third message"

# Step 2: Test scaling
kubectl scale deployment frontend --replicas=5
kubectl get pods

# Step 3: Test rolling update
kubectl set image deployment/frontend php-redis=gcr.io/google_samples/gb-frontend:v6
kubectl rollout status deployment/frontend

# Step 4: Test rollback
kubectl rollout undo deployment/frontend

# Step 5: Create assessment
cat > WEEK2_ASSESSMENT.md << 'EOF'
# Week 2 Assessment

## Knowledge Check
- [ ] Can create ClusterIP, NodePort, and LoadBalancer Services
- [ ] Understand Service selectors and endpoints
- [ ] Can create and use ConfigMaps
- [ ] Can create and use Secrets
- [ ] Understand Ingress and can create Ingress rules
- [ ] Deployed multi-tier Guestbook application

## Hands-on Tasks
1. Create a Service that exposes a deployment internally
2. Create a ConfigMap and mount it as a volume
3. Create a Secret and use it as environment variables
4. Create an Ingress with host-based routing
5. Deploy the complete Guestbook application

## Troubleshooting Scenarios
- Service not connecting to pods → check selectors
- ConfigMap not updating → need pod restart
- Secret values visible → base64 is encoding, not encryption
- Ingress not working → check controller installation
EOF