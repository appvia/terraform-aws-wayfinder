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
    tlsSecret: "wayfinder-ingress-api-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/proxy-buffer-size: '16k'
    namespace: "ingress-nginx"
    className: "nginx"
  wayfinderInstanceIdentifier: "${wayfinder_instance_identifier}"
disableLocalLogin: ${disable_local_login}
enableLocalAdminUser: ${enable_localadmin_user}
mysql:
  pvc:
    storageClass: "${storage_class}"
    size: "${auditdb_pvc_size}"
noDefaults: ${no_defaults}
ui:
  customLogoURL: "${custom_logo_url}"
  customLogoCollapsedURL: "${custom_logo_collapsed_url}"
  enabled: true
  endpoint:
    url: "https://${ui_hostname}"
  ingress:
    enabled: true
    hostname: "${ui_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ingress-ui-tls"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    namespace: "ingress-nginx"
    className: "nginx"
workloadIdentity:
  aws:
    roleARN: "${wayfinder_iam_identity}"
