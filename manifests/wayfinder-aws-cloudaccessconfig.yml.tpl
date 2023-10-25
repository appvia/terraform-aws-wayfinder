apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudAccessConfig
metadata:
  name: ${name}
  namespace: ws-admin
spec:
  cloud: aws
  aws:
    account: "${account_id}"
    defaultRegion: ${region}
  description: ${description}
  type: ${type}
  cloudIdentityRef:
    cloud: aws
    name: ${identity}
  permissions:
  - permission: ${permission}
    awsRole: ${role_arn}
