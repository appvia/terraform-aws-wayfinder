apiVersion: cloudaccess.appvia.io/v2beta1
kind: CloudAccessConfig
metadata:
  name: aws-admin
  namespace: ws-admin
spec:
  cloud: aws
  defaultRegion: ${region}
  features:
  - DNSZoneManagement
  - CostsEstimates
  identifier: "${account_id}"
  identityCred:
    name: cloudidentity-aws
    namespace: ws-admin
  name: aws-admin
  roles:
  - assumeProviderRole: ${dns_zone_manager_role_arn}
    cloudResourceName: wf-DNSZoneManager-${identifier}
    role: DNSZoneManager
  - assumeProviderRole: ${cloud_info_role_arn}
    cloudResourceName: wf-CloudInfo-${identifier}
    role: CloudInfo
