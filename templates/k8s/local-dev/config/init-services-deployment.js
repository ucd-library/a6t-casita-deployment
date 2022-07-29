module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : '{{CASITA_INIT_IMAGE_NAME_TAG}}',
  "SERVICE_NAME" : "init-services-deployment",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "tail -f /dev/null"],
  "env" : [
    {"name": "PG_DATABASE", "value": "casita"},
    {"name": "MAX_WORKERS", "value": "15"}
  ],
  volumes: [
    {
      "name": "service-account-key", 
      "hostPath": "casita-deployment/casita-local-dev/service-account.json",
      "type": "File",
      "mountPath": "/etc/service-account.json"
    }
  ]
})