📋 S3 CLI Commands Cheat Sheet

Bucket Operations
bash

# List buckets

aws s3 ls

# Create bucket

aws s3 mb s3://my-bucket

# Delete bucket (must be empty)

aws s3 rb s3://my-bucket

# Force delete with contents

aws s3 rb s3://my-bucket --force

Object Operations
bash

# Upload file

aws s3 cp file.txt s3://my-bucket/

# Upload with specific storage class

aws s3 cp file.txt s3://my-bucket/ --storage-class STANDARD_IA

# Download file

aws s3 cp s3://my-bucket/file.txt .

# List objects

aws s3 ls s3://my-bucket/
aws s3 ls s3://my-bucket/folder/  # List specific folder

# Sync directory (like rsync)

aws s3 sync ./local-folder s3://my-bucket/remote-folder

# Remove object

aws s3 rm s3://my-bucket/file.txt

# Move object

aws s3 mv s3://my-bucket/old-name s3://my-bucket/new-name

Advanced Operations
bash

# Enable versioning

aws s3api put-bucket-versioning \
    --bucket my-bucket \
    --versioning-configuration Status=Enabled

# Get bucket policy

aws s3api get-bucket-policy --bucket my-bucket

# Put bucket policy

aws s3api put-bucket-policy --bucket my-bucket --policy file://policy.json

# Generate presigned URL (expires in 3600 seconds)

aws s3 presign s3://my-bucket/file.txt --expires-in 3600