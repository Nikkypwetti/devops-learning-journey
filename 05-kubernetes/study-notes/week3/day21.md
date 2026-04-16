# Step 1: Review all concepts
cat > WEEK3_REVIEW.md << 'EOF'
# Week 3 Review

## Key Concepts
1. **Persistent Storage**: PVCs, PVs, StorageClasses
2. **StatefulSets**: Stateful applications, stable network IDs
3. **Jobs/CronJobs**: Batch processing, scheduled tasks
4. **DaemonSets**: Node-level agents, log collection
5. **Voting App**: Complete microservices deployment

## Commands Review
- `kubectl get pvc,pv`
- `kubectl get statefulset`
- `kubectl get job,cronjob`
- `kubectl get daemonset`

## Troubleshooting Common Issues
- Pods stuck in Pending → Check resources
- CrashLoopBackOff → Check logs and commands
- ImagePullBackOff → Check image name and registry
- PVC pending → Check storage class
EOF

# Step 2: Create final voting app README
cat > ~/k8s-projects/voting-app/README.md << 'EOF'
# Voting Application on Kubernetes

## Architecture
- **Frontend**: Voting UI (2 replicas) + Results UI (2 replicas)
- **Backend**: Redis (votes storage), PostgreSQL (results storage)
- **Worker**: Processes votes between Redis and PostgreSQL

## Access
```bash
Voting UI: minikube service voting-app --url
Results UI: minikube service result-app --url

Scale Testing
bash

kubectl scale deployment voting-app --replicas=5
kubectl scale deployment result-app --replicas=5

Cleanup
bash

kubectl delete -f .
