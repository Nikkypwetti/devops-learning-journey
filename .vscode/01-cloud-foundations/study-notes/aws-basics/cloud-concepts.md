Cloud Computing Concepts
Created: 2025-11-20
Updated: 2025-12-1
📚 Core Concepts
Six Advantages of Cloud Computing

    Trade capital expense for variable expense

        No upfront costs, pay only for what you use

        Example: Instead of buying servers, pay hourly for EC2

    Benefit from massive economies of scale

        AWS can offer lower prices due to volume

        Prices decrease over time

    Stop guessing capacity

        Scale up or down based on actual demand

        No over-provisioning or under-provisioning

        Example: Auto Scaling groups adjust based on traffic

    Increase speed and agility

        Launch resources in minutes, not months

        Experiment quickly with new technologies

        Reduce time to market for applications

    Stop spending money running and maintaining data centers

        Focus on applications, not infrastructure

        AWS manages hardware, facilities, and physical security

        Reduced operational overhead

    Go global in minutes

        Deploy applications in multiple regions worldwide

        Low latency for end users

        Disaster recovery across regions

Deployment Models

    Public Cloud: AWS, Azure, GCP (shared infrastructure, multi-tenant)

    Private Cloud: On-premises cloud infrastructure (dedicated to one organization)

    Hybrid Cloud: Mix of public and private (data/workload portability)

Service Models

    IaaS (Infrastructure as a Service): EC2, VPC, EBS (maximum control)

    PaaS (Platform as a Service): Elastic Beanstalk, RDS (managed platform)

    SaaS (Software as a Service): Office 365, Salesforce (complete applications)

Key AWS Concepts

    Regions: Geographic areas (us-east-1, eu-west-1)

    Availability Zones: Isolated locations within regions (data centers)

    Edge Locations: Points of presence for CloudFront (CDN)

    Shared Responsibility Model: AWS secures the cloud, you secure what's in the cloud

💡 My Insights

    Cloud is like electricity grid vs owning generator

    Startups benefit most from no upfront costs

    Large enterprises can migrate gradually

    Cost optimization becomes a continuous process

    The real value is in managed services, not just virtual machines

❓ Questions to Explore

    How does AWS actually achieve multi-tenancy?

    What are the security implications of public cloud?

    How do reserved instances vs spot instances affect cost structure?

    What are the trade-offs between different storage classes?

    How does AWS ensure data durability across availability zones?

🔧 Practical Considerations

    Always design for failure (nothing is 100% reliable)

    Implement cost monitoring and budgeting from day one

    Use infrastructure as code (CloudFormation, Terraform)

    Start with the Well-Architected Framework principles

🔗 Related Topics

    [[../ec2/ec2-basics.md]]

    [[../s3/s3-basics.md]]

    [[../vpc/vpc-basics.md]]

    [[../iam/iam-basics.md]]

Next steps: Explore specific AWS services, starting with EC2 for compute and S3 for storage.
