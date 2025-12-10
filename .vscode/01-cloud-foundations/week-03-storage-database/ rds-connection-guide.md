# Connecting to Amazon RDS from Various Clients

## Prerequisites

- RDS instance is running and available
- Security group allows your IP on port:
  - MySQL/MariaDB: 3306
  - PostgreSQL: 5432
  - Oracle: 1521
  - SQL Server: 1433
- Database username and password
- RDS endpoint URL

## Connection Methods

### 1. MySQL/MariaDB Connection

#### Using MySQL Client

```bash
# Install MySQL client
sudo yum install mysql  # Amazon Linux
sudo apt-get install mysql-client  # Ubuntu

# Connect to RDS
mysql -h your-database.123456789012.us-east-1.rds.amazonaws.com \
      -P 3306 \
      -u admin \
      -p

Using MySQL Workbench

    Open MySQL Workbench

    Click "+" to add new connection

    Configure:

        Connection Name: MyRDS

        Hostname: your-database.123456789012.us-east-1.rds.amazonaws.com

        Port: 3306

        Username: admin

        Password: [your-password]

    Test Connection

2. PostgreSQL Connection
Using psql
bash

# Install PostgreSQL client
sudo yum install postgresql  # Amazon Linux
sudo apt-get install postgresql-client  # Ubuntu

# Connect to RDS
psql -h your-database.123456789012.us-east-1.rds.amazonaws.com \
     -p 5432 \
     -U postgres \
     -d postgres

3. Application Connection Strings
Python (MySQL)
python

import mysql.connector

config = {
    'user': 'admin',
    'password': 'your-password',
    'host': 'your-database.123456789012.us-east-1.rds.amazonaws.com',
    'database': 'mydb',
    'port': '3306',
    'ssl_ca': 'rds-ca-2019-root.pem'  # Download from AWS
}

connection = mysql.connector.connect(**config)

Node.js (MySQL)
javascript

const mysql = require('mysql');

const connection = mysql.createConnection({
  host: 'your-database.123456789012.us-east-1.rds.amazonaws.com',
  user: 'admin',
  password: 'your-password',
  database: 'mydb',
  port: 3306,
  ssl: 'Amazon RDS'
});

PHP (MySQL)
php

<?php
$servername = "your-database.123456789012.us-east-1.rds.amazonaws.com";
$username = "admin";
$password = "your-password";
$dbname = "mydb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

4. SSL/TLS Configuration
Download RDS SSL Certificate
bash

wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

Connect with SSL (MySQL)
bash

mysql -h your-database.123456789012.us-east-1.rds.amazonaws.com \
      -u admin \
      -p \
      --ssl-ca=global-bundle.pem \
      --ssl-mode=REQUIRED

5. IAM Database Authentication (MySQL/Aurora)
Create IAM Policy
json

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rds-db:connect",
      "Resource": "arn:aws:rds-db:us-east-1:123456789012:dbuser:db-ABCDEFGHIJKL01234/*"
    }
  ]
}

Generate IAM Auth Token
bash

RDSHOST="your-database.123456789012.us-east-1.rds.amazonaws.com"
USERNAME="iam_user"
TOKEN="$(aws rds generate-db-auth-token \
          --hostname $RDSHOST \
          --port 3306 \
          --username $USERNAME \
          --region us-east-1)"

mysql -h $RDSHOST -P 3306 --ssl-ca=global-bundle.pem --enable-cleartext-plugin -u $USERNAME -p$TOKEN

Troubleshooting

    Connection timeout: Check security group rules

    Access denied: Verify username/password

    Too many connections: Check max_connections parameter

    SSL errors: Download latest RDS certificate bundle

Security Best Practices

    Use SSL/TLS for all connections

    Store credentials in AWS Secrets Manager

    Use IAM roles for applications on EC2

    Enable encryption at rest

    Use VPC Security Groups and Network ACLs