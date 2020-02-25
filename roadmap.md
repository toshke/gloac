
### Provisioning

- Seperate stack to build AMI and Docker Image using CodeBuild
- Customize AMI 
- AMI OS hardening for security standards

### Networking

- Provision VPC or provide subnets
- Public or privately accessible
- Public IP EC2 instance or ALB (cost decision)
- Route53 zone / record 
- SSH with NLB
- NAT Gateway / NAT Instance / Instances in Public Subnets

#### Privately accessible
 
- Provision client VPN ? 
- Internal Route53 record ?

### Backups

- AWS Backups
- Schedule
- Redis backups

### Operations / monitoring

- SSH directly or via SSM 
- Logs to Cloudwatch via agent

### HA

- Pilot light in another AZ with replicated FS
- Snapshot / Restore into another AZ

### Data

- (Cost Saving) PostgreSQL on same instance w/separate EBS volume
-  PostgreSQL on RDS
- (Cost Saving) Redis on same instance w/seperate EBS volume
-  Reds on ElastiCache
