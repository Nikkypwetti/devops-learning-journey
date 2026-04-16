# Week 2: Networking & Configuration - Daily Resources

## 📅 **Week Overview**
**Focus:** Services, ConfigMaps, Secrets, Ingress  
**Duration:** 7 days  
**Success Metric:** Deploy Guestbook application with Redis

---

## 📘 **Day 8: Services - Exposing Applications**

### **🎯 Learning Objectives**
- Understand different Service types (ClusterIP, NodePort, LoadBalancer)
- Create and use Services
- Understand Service selectors and endpoints

### **📚 Morning Resources (6:00-7:00 AM)**
#### **Video Tutorial (25 mins):**
- **[Kubernetes Services Explained](https://www.youtube.com/watch?v=T4Z7faMM1D0)** - TechWorld with Nana
- **Key topics covered:**
  - Why we need Services (pods are ephemeral)
  - ClusterIP (internal communication)
  - NodePort (external access via node IP)
  - LoadBalancer (cloud load balancers)

#### **Reading Material (15 mins):**
- [Services Overview](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

#### **Concept Examples (20 mins):**

**ClusterIP Service (default - internal only):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: ClusterIP
  selector:
    app: backend
    tier: api
  ports:
  - port: 8080
    targetPort: 8080

NodePort Service (external access):
yaml

apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30080  # Optional, range 30000-32767