api:
  aws:
    wayfinderIamIdentity: "${wayfinder_iam_identity}"
  enabled: true
  endpoint:
    url: "https://${api_hostname}"
  ingress:
    enabled: true
    hostname: "${api_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-api-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    namespace: "ingress-nginx"
    className: "nginx"
  wayfinderInstanceIdentifier: "${wayfinder_instance_identifier}"
  wfManagedWfCluster: true
mysql:
  pvc:
    storageClass: "${storage_class}"
ui:
  enabled: true
  endpoint:
    url: "https://${ui_hostname}"
  ingress:
    enabled: true
    hostname: "${ui_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ui-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    namespace: "ingress-nginx"
    className: "nginx"
