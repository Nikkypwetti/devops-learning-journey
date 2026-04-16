📘 Day 2: Kubernetes Architecture Deep Dive

Date: [02/04/2026]
Topic: Understanding the "Control Plane" vs. "Worker Nodes" and the role of Pods.

🎯 Learning Objectives (My Checklist)

    Understand Control Plane components in detail.

    Learn about Worker Node components.

        Understand Pods as the smallest deployable units.

📚 Morning Notes (6:00-7:00 AM)
The Big Picture: Control Plane vs. Worker Nodes

Think of a Kubernetes cluster like a company.

    The Control Plane (Management/Head Office): Makes global decisions, manages the state of the cluster, and responds to events. You don't run your apps here; you run the managers.

    Worker Nodes (The Factory Floor): The machines where your actual applications (containers) run. They do the heavy lifting.

🧠 Control Plane Components (The Brains)

These are usually spread across multiple master nodes for high availability.

    kube-apiserver (The Front Desk/Gatekeeper)

        What it is: The only component that talks to the etcd database. All communication (from kubectl, other components, or external users) goes through the API server.

        Why it matters: It validates and configures data for API objects (like pods, services). If you can't reach the API server, you can't control the cluster.

    etcd (The Source of Truth)

        What it is: A highly reliable, distributed key-value store.

        Why it matters: It stores the entire configuration and status of the cluster. What pods are running, what nodes exist, what secrets are stored. No etcd = No cluster state. (Backup this!)

    kube-scheduler (The Assignment Manager)

        What it does: Watches for newly created pods that have no node assigned.

        Decision process: It considers resource requirements, hardware/software constraints, affinity rules, etc., and picks the best Worker Node for the pod.

        Note: It chooses the node but doesn't do the actual work of running the container.

    kube-controller-manager (The Fixer)

        What it does: Runs background threads (controllers) that watch the shared state of the cluster via the API server.

        Examples of Controllers:

            Node Controller: Notices when a node goes down and responds.

            Replication Controller: Ensures the correct number of pod replicas are running.

            Endpoint Controller: Connects Services to Pods.

    cloud-controller-manager (The Cloud Connector)

        What it does: Lets Kubernetes interact with a cloud provider's API (AWS, GCP, Azure).

        Example: It can create Load Balancers, Persistent Disks, or update VMs.

💪 Worker Node Components (The Muscles)

    kubelet (The Foreman)

        Critical: The most important component on the node.

        What it does: It receives "PodSpecs" (blueprints) and ensures the containers described in those PodSpecs are running and healthy. It reports back to the control plane.

    kube-proxy (The Network Traffic Cop)

        What it does: Maintains network rules on the node. It allows network communication to your pods from inside or outside the cluster.

        Simple analogy: It knows the IP address of every pod and load balances traffic between them.

    Container Runtime (The Container Launcher)

        What it is: The software that actually runs the containers. Examples: Docker, containerd, CRI-O.

        Relationship: kubelet tells the runtime what to run, the runtime runs it.

📦 Pods: The Smallest Deployable Units

    What is it? An abstraction over one or more containers. You never run a single container in K8s; you always run a Pod.

    The "Shared Context" rule: All containers inside a single Pod share the same:

        Network namespace (same IP address and port space).

        IPC namespace (can communicate via shared memory).

        Volume storage (can share disks).

    Sidecar Pattern: A classic use case. One container runs your main app (e.g., a web server), and another container runs a helper (e.g., a log collector) that lives in the same Pod.

    Ephemeral: Pods are not designed to be permanent. They can be killed and recreated. You never "repair" a pod; you replace it.

💻 Evening Practice Log (6:30-8:00 PM)
Lab: Exploring My Minikube Cluster

Pre-step: Ensure minikube is running.
bash

minikube status

Step 1: List all system components
bash

kubectl get pods -n kube-system

Observation: I see etcd-minikube, kube-apiserver-minikube, kube-controller-manager-minikube, kube-scheduler-minikube, coredns, and kube-proxy. Note the -minikube suffix because it's a single-node cluster.

Step 2: Inspect the API Server
bash

kubectl get pod kube-apiserver-minikube -n kube-system -o yaml | head -50

Takeaway: The YAML output is huge. It defines the container image, ports (6443 for HTTPS), and the startup command arguments (e.g., --service-cluster-ip-range). This shows how the API server is configured.

Step 3: Check the Scheduler
bash

kubectl get pod kube-scheduler-minikube -n kube-system -o wide

Takeaway: It's running on the minikube node (since there's only one node). If this fails, new pods can't be placed.

Step 4: Describe the Node
bash

kubectl describe node minikube

Key Findings:

    Conditions: Ready=True (node is healthy). MemoryPressure=False.

    Capacity: CPU: 4, Memory: ~3.8Gi (depends on my VM settings).

    Allocated resources: Shows how much CPU/memory is already used by system pods.

    Non-terminated Pods: Lists all pods currently running on this node.

Step 5: Watch Events (Live Action)
Terminal 1:
bash

kubectl get events --watch --all-namespaces

Terminal 2:
bash

kubectl run test-pod --image=nginx --restart=Never

Back to Terminal 1: I saw events appear in real-time:

    Scheduled (Scheduler chose the node)

    Pulled (kubelet pulled the image)

    Created (Container runtime created container)

    Started (Container started)

Step 6: Clean up
bash

kubectl delete pod test-pod

Advanced Exploration (etcd)
bash

kubectl exec -it etcd-minikube -n kube-system -- sh
export ETCDCTL_API=3
etcdctl get / --prefix --keys-only | head -20

Note: This is messy output because everything is stored here. I see keys for /registry/pods/, /registry/nodes/, etc. This proves etcd is the source of truth.
📝 Architecture Diagram (Mental Model / Sketch)
text

[ kubectl ] ---(HTTPS)---> [ API Server (Control Plane) ]
                              |       |         |
                              v       v         v
                          [ etcd ] [ Scheduler ] [ Controller Manager ]
                              ^       |         |
                              |       v         v
                              |   [ Worker Node ]
                              |       |
                              |   [ kubelet ] ---> [ Container Runtime ] ---> [ Pod (Container) ]
                              |       |
                              |   [ kube-proxy ] ---> (Network Rules)
                              |
                              +---(Persistent Store)----+

How kubectl run nginx flows:

    kubectl sends YAML to API Server.

    API Server writes to etcd.

    Scheduler sees "pending" pod, picks a node, tells API Server.

    kubelet on that node sees the assignment, tells Container Runtime to pull nginx and start the container inside a Pod.

    Controller Manager verifies 1 replica exists (it does).

    kube-proxy updates IP tables so the pod can be reached.

🔗 Key Takeaways & Questions for Tomorrow

    The API Server is the ONLY component that touches etcd. This is a crucial security and design point.

    Pods are not containers, they are environments for containers.

    I need to understand kube-proxy better. How exactly do IP tables work? (Tomorrow's topic: Networking).

    Practice command: kubectl explain pod – I should use this more to understand fields.

Time spent: 1.5 hours (Morning) + 1.5 hours (Lab). ✅ Objectives met.