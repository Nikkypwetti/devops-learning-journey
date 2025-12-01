# Design Decisions

## Architecture Overview
This IAM strategy implements a multi-account AWS organization structure with centralized identity management.

## Account Structure
1. **Management Account (111111111111)**
   - Central IAM user management
   - Cross-account roles
   - Organization-wide policies

2. **Production Account (222222222222)**
   - Live application workloads
   - Restricted access
   - Enhanced monitoring

3. **Development Account (333333333333)**
   - Development and testing
   - Flexible permissions
   - Innovation sandbox

4. **Security Account (444444444444)**
   - Central logging
   - Security monitoring
   - Compliance reporting

## IAM Design Principles

### 1. Least Privilege
- Each role/group has minimum required permissions
- Regular permission reviews scheduled
- Just-in-time access for elevated privileges

### 2. Separation of Duties
- Development teams cannot access production
- Security team has read-only audit access
- Finance team only sees billing information

### 3. Defense in Depth
- MFA required for all human users
- Break glass access with strict controls
- Regular credential rotation

### 4. Centralized Management
- IAM users only in management account
- Cross-account role assumption
- Single source of truth for identities

## Policy Design

### Break Glass Emergency Policy
- Requires MFA
- Time-limited access (1 hour)
- Full administrative privileges
- Only for emergency situations

### Read-Only Audit Policy
- View-only access to all resources
- No modification capabilities
- Access to CloudTrail, Config, and logs

### Power User Dev Policy
- Full access to development resources
- Regional restrictions (us-east-1, eu-west-1)
- Explicit denial of production access
- No IAM user management

### Cost Explorer Policy
- View billing and cost information
- Cannot modify budgets or tags
- Finance team access only