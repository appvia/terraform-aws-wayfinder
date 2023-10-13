apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudIdentity
metadata:
  name: ${name}
  namespace: ws-admin
spec:
  cloud: aws
  type: AWSIAMRoleForServiceAccount
  aws:
    roleARN: ${role_arn}
