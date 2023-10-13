apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudAccessConfig
metadata:
  name: aws-dnsmanagement
  namespace: ws-admin
spec:
  cloud: aws
  aws:
    account: ${account_id}
    defaultRegion: ${region}
  description: Platform cloud metadata access, created by Wayfinder install
  type: CostEstimates
  cloudIdentityRef:
    cloud: aws
    name: ${identity}
  permissions:
  - permission: DNSZoneManager
    awsRole: ${dns_zone_manager_role_arn}
