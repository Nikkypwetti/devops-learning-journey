# High Availability Web App Architecture

```mermaid
graph TB
    User[Internet User] --> ALB[Application Load Balancer]
    
    ALB --> TG[Target Group]
    
    subgraph AutoScalingGroup[Auto Scaling Group]
        direction TB
        EC2_1[EC2 Instance<br/>AZ: us-east-1a]
        EC2_2[EC2 Instance<br/>AZ: us-east-1b]
        EC2_3[EC2 Instance<br/>AZ: us-east-1c]
    end
    
    TG --> EC2_1
    TG --> EC2_2
    TG --> EC2_3
    
    CloudWatch[CloudWatch Metrics] --> ScalingPolicy[Scaling Policy]
    ScalingPolicy --> AutoScalingGroup
    
    EC2_1 --> S3[S3 for Static Assets]
    EC2_2 --> S3
    EC2_3 --> S3