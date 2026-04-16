# Week 3: Advanced Workloads - Daily Resources

## 📅 **Week Overview**
**Focus:** Persistent storage, StatefulSets, Jobs, CronJobs, DaemonSets  
**Duration:** 7 days  
**Success Metric:** Deploy voting application with persistent storage

---

## 📘 **Day 15: Volumes & Persistent Storage**

### **🎯 Learning Objectives**
- Understand Kubernetes volume types
- Create PersistentVolumeClaims (PVCs)
- Use StorageClasses for dynamic provisioning

### **📚 Morning Resources (6:00-7:00 AM)**
#### **Video Tutorial (25 mins):**
- **[Kubernetes Volumes Explained](https://www.youtube.com/watch?v=0swQ5CbgGQ4)** - TechWorld with Nana
- **Key topics covered:**
  - emptyDir, hostPath volumes
  - PersistentVolume (PV) and PersistentVolumeClaim (PVC)
  - StorageClasses for dynamic provisioning

#### **Reading Material (15 mins):**
- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

### **💻 Evening Practice (6:30-8:00 PM)**
#### **Lab: Persistent Storage (60 mins)**

```bash
# Step 1: Create a PVC
mkdir -p ~/k8s-manifests/storage
cd ~/k8s-manifests/storage

cat > pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

kubectl apply -f pvc.yaml
kubectl get pvc

# Step 2: Use PVC in a pod
cat > pod-with-pvc.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pvc-demo-pod
spec:
  volumes:
  - name: my-storage
    persistentVolumeClaim:
      claimName: my-pvc
  containers:
  - name: app
    image: alpine:latest
    command: ["sleep", "infinity"]
    volumeMounts:
    - name: my-storage
      mountPath: /data
EOF

kubectl apply -f pod-with-pvc.yaml

# Step 3: Write data and verify persistence
kubectl exec pvc-demo-pod -- sh -c "echo 'Hello Persistent Storage' > /data/test.txt"
kubectl exec pvc-demo-pod -- cat /data/test.txt

# Delete the pod
kubectl delete pod pvc-demo-pod

# Create a new pod with same PVC
kubectl apply -f pod-with-pvc.yaml

# Data should still be there
kubectl exec pvc-demo-pod -- cat /data/test.txt

# Step 4: Clean up
kubectl delete pod pvc-demo-pod
kubectl delete pvc my-pvc