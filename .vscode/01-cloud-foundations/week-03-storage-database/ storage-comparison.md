# AWS Storage Services Comparison Cheatsheet

## Quick Decision Tree

Question: What type of data?
├── Object storage (files, backups, media) → S3
├── Block storage (databases, OS volumes) → EBS
├── File storage (shared access, CMS) → EFS
├── Relational data (structured, SQL) → RDS
└── NoSQL data (unstructured, high scale) → DynamoDB

## Detailed Comparison Table

| Service | Type | Max Size | Access Pattern | Durability | Availability | Latency | Use Cases | Cost Model |
|---------|------|----------|----------------|------------|--------------|---------|-----------|------------|
| **S3** | Object | Unlimited | HTTP/REST API | 99.999999999% | 99.99% | 100-200ms | Backups, static websites, data lakes | Storage + requests + data transfer |
| **EBS** | Block | 16TB/volume | Single EC2 | 99.8-99.9% | 99.9% | <1ms | Boot volumes, databases, file systems | GB-month + IOPS + snapshots |
| **EFS** | File | Petabytes | NFSv4 (multiple EC2) | 99.999999999% | 99.9% | <3ms | Web serving, content management | GB-month + throughput |
| **RDS** | Relational DB | 64TB (Aurora: 128TB) | SQL endpoint | 99.999% (Multi-AZ) | 99.95% | <10ms | OLTP, applications, reporting | Instance + storage + IOPS + backup |
| **DynamoDB** | NoSQL | Unlimited | SDK/API | 99.999999999% | 99.99% | <10ms | Serverless apps, high-scale web | RCU/WCU or on-demand |
| **Glacier** | Archive | Unlimited | Async retrieval | 99.999999999% | 99.99% | Min-hours | Compliance, long-term backups | Storage + retrieval + requests |
| **Instance Store** | Ephemeral Block | Instance-dependent | Single EC2 | Low (ephemeral) | Instance-dependent | Sub-ms | Cache, temp data, scratch | Included with EC2 |

## Storage Class Comparison (S3)

| Class | Min Storage Duration | Retrieval Time | Min Billable Object | Use Case |
|-------|---------------------|----------------|---------------------|----------|
| **Standard** | None | Milliseconds | N/A | Frequently accessed data |
| **Intelligent-Tiering** | None | Milliseconds | 128KB | Unknown/fluctuating access |
| **Standard-IA** | 30 days | Milliseconds | 128KB | Infrequent access |
| **One Zone-IA** | 30 days | Milliseconds | 128KB | Re-creatable infrequent data |
| **Glacier Instant** | 90 days | Milliseconds | 128KB | Archive with instant access |
| **Glacier Flexible** | 90 days | Min-hours | 40KB | Long-term archive |
| **Glacier Deep** | 180 days | 12+ hours | 40KB | Rarely accessed archive |

## EBS Volume Types

| Type | Description | Max IOPS | Max Throughput | Use Case |
|------|-------------|----------|----------------|----------|
| **gp3** | General Purpose SSD | 16,000 | 1,000 MB/s | Boot volumes, dev/test |
| **io2** | Provisioned IOPS SSD | 256,000 | 4,000 MB/s | Critical databases |
| **st1** | Throughput HDD | 500 | 500 MB/s | Big data, data warehouses |
| **sc1** | Cold HDD | 250 | 250 MB/s | Infrequently accessed data |

## Performance Characteristics

### Latency Comparison

Instance Store (0.1ms) < EBS (1ms) < EFS (3ms) < RDS (10ms) < DynamoDB (10ms) < S3 (100ms)

### Throughput Scaling

- **S3**: Scales automatically to 3,500 PUT/5,500 GET requests/sec per prefix
- **EBS**: Limited per volume, scale by volume type/size
- **EFS**: Scales with usage, up to GB/s throughput
- **DynamoDB**: Scales horizontally, unlimited throughput
- **RDS**: Vertical scaling (instance size), horizontal with read replicas

## Cost Optimization Tips

### S3 Cost Saving

1. Use lifecycle policies to move to cheaper classes
2. Enable S3 Intelligent-Tiering for unknown patterns
3. Compress data before uploading
4. Use Requester Pays for large datasets shared externally

### EBS Cost Saving

1. Delete unattached volumes
2. Use gp3 instead of gp2 (30% cheaper, separate IOPS pricing)
3. Schedule snapshots during off-hours
4. Use smaller volumes with higher IOPS if needed

### RDS Cost Saving

1. Use Reserved Instances for predictable workloads
2. Scale down during non-business hours
3. Use Aurora Serverless for variable workloads
4. Delete old snapshots and automated backups

### DynamoDB Cost Saving

1. Use on-demand for unpredictable traffic
2. Use auto-scaling for predictable patterns
3. Enable TTL to auto-delete old items
4. Use sparse indexes

## Security Comparison

| Service | Encryption at Rest | Encryption in Transit | IAM Integration | Network Isolation |
|---------|-------------------|----------------------|-----------------|-------------------|
| **S3** | SSE-S3, SSE-KMS, SSE-C | TLS 1.2+ | Bucket policies, ACLs | VPC Endpoints |
| **EBS** | AWS KMS | Within EC2 instance | IAM roles | VPC, Security Groups |
| **EFS** | AWS KMS | TLS (with mount helper) | IAM, POSIX permissions | VPC, Security Groups |
| **RDS** | AWS KMS | SSL/TLS | IAM authentication | VPC, Security Groups |
| **DynamoDB** | AWS KMS | HTTPS | Fine-grained IAM policies | VPC Endpoints |

## Use Case Examples

### Scenario 1: E-commerce Website

- **Product images**: S3 + CloudFront CDN
- **Database**: RDS MySQL Multi-AZ
- **Session data**: DynamoDB
- **Backups**: S3 Glacier

### Scenario 2: Big Data Analytics

- **Raw data lake**: S3
- **Processing**: EMR with HDFS on S3
- **Results**: S3 or DynamoDB for query results
- **Archive**: S3 Glacier Deep Archive

### Scenario 3: Content Management System

- **Shared files**: EFS
- **Database**: RDS PostgreSQL
- **Static assets**: S3
- **User uploads**: S3 with lifecycle to IA

### Scenario 4: Mobile App Backend

- **User data**: DynamoDB
- **File uploads**: S3
- **Analytics**: S3 + Athena
- **Cached data**: ElastiCache (not covered this week)

## Migration Considerations

### When to Move Between Services

1. **EBS → EFS**: When needing shared access between instances
2. **RDS → DynamoDB**: When schema is flexible and scale is needed
3. **S3 Standard → Glacier**: After 30-90 days of no access
4. **On-premises → AWS**: Use Storage Gateway, DataSync, or Snow family

### Monitoring Metrics

- **S3**: Requests, bytes transferred, storage used
- **EBS**: IOPS, throughput, queue depth
- **EFS**: IOPS, throughput, metered size
- **RDS**: CPU, memory, connections, storage
- **DynamoDB**: Consumed RCU/WCU, latency, errors

## Best Practices Summary

1. **Always encrypt** data at rest and in transit
2. **Enable versioning** on S3 for critical data
3. **Use Multi-AZ** for production RDS and critical EFS
4. **Implement lifecycle policies** for cost optimization
5. **Monitor costs** with Cost Explorer and budgets
6. **Test backup and restore** procedures regularly
7. **Use VPC endpoints** for private access to S3/DynamoDB
8. **Implement least privilege** access with IAM