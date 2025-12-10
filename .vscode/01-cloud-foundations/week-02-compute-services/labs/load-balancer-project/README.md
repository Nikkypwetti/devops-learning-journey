# 🚀 AWS High Availability Web App  

### Load Balancer + Auto Scaling + EC2 Metadata Demo  

**By: Nikkypwetti**

This project is a high-availability web application deployed on AWS using:

- Amazon EC2  
- Application Load Balancer (ALB)  
- Auto Scaling Group (ASG)  
- Instance Metadata Service (IMDS)  
- PM2 (Process Manager)  
- User Data for automated provisioning  

The goal is to demonstrate fault tolerance, scalability, and load distribution across multiple instances.

---

## 📌 Features

### ✅ **High Availability**

Traffic is distributed across EC2 instances using an **Application Load Balancer**.

### ✅ **Auto Scaling**

Instances automatically **scale out/in** based on load or capacity.

### ✅ **Metadata Integration**

Each server displays:
- Instance ID  
- Availability Zone  
- Request counter per instance  
- Current time  

This helps visualize live load balancing.

### ✅ **Health Checks**

ALB health check endpoint:

/health

### ✅ **Graceful Shutdown**

Handles EC2 scale-in events safely using:
```js
process.on('SIGTERM', ...)

✅ PM2 Process Management

Ensures the app auto-starts after reboot.

📁 Project Structure
devops-learning-journey/
└── 01-cloud-foundations/
    └── week-02-compute-services/
        └── labs/
            └── load-balancer-project/
                ├── app.js
                ├── package.json
                ├── user-data.sh
                └── README.md   ← (this file)

⚙️ Installation (Local)

1. Clone repository

git clone https://github.com/Nikkypwetti/devops-learning-journey.git
cd devops-learning-journey/01-cloud-foundations/week-02-compute-services/labs/load-balancer-project

2. Install dependencies

npm install

3. Create a .env file

Create a `.env` file in the project root with the following content:
INSTANCE_ID=local-dev
AVAILABILITY_ZONE=local
APP_PORT=3000

4. Start server

node app.js

☁️ Deployment on AWS EC2 (Auto Setup)
Your EC2 User Data automatically:

Installs Node.js & PM2

Clones your GitHub repo

Fetches EC2 metadata

Writes .env

Starts app with PM2

Example User Data:
#!/bin/bash
set -e

dnf update -y
dnf install -y nodejs npm git

npm install -g pm2

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cd /home/ec2-user

git clone https://github.com/Nikkypwetti/devops-learning-journey.git
cd devops-learning-journey/01-cloud-foundations/week-02-compute-services/labs/load-balancer-project

cat <<EOF > .env
INSTANCE_ID=$INSTANCE_ID
AVAILABILITY_ZONE=$AVAILABILITY_ZONE
APP_PORT=3000
EOF

npm install
pm2 start app.js --name ha-web-app
pm2 save
pm2 startup systemd

🌐 Routes

Route	Description
/	Main page showing EC2 details & load balancing demo
/health	ALB health check (must return 200 OK)

📊 What You’ll See

Every time you refresh the page, the ALB may send you to a different EC2 instance, showing:

Different request counters

Different instance IDs

Different availability zones

This proves high availability & load distribution.

🧪 Testing Load Balancing

Use a loop test:

for i in {1..20}; do curl -s http://<ALB-DNS>; echo ""; done


You will see multiple instance IDs responding.

🔥 Auto Scaling Behavior
Scale Out

Triggered by metrics such as:

CPU > 60%

Network spikes

Custom rules

Scale In

Application receives:

SIGTERM


Your app handles this safely.

📦 PM2 Commands (On EC2)
pm2 status
pm2 logs ha-web-app
pm2 restart ha-web-app
pm2 stop ha-web-app

💰 Cost Optimization

Use t2.micro or t3.micro (Free Tier)

Use minimum capacity = 1 in Auto Scaling

Use scale-out only on CPU > 70%

Delete EC2 + ALB after testing to avoid charges

📜 License

MIT License

👨‍💻 Author

Nikkypwetti
DevOps & Cloud Engineering Learner

📝 Notes

This project is part of Week 2 – Compute Services in the DevOps Learning Journey.
