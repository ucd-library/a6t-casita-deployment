module.exports = config => ({
  name : 'init-services',
  containers : [{
    name : 'kafka',
    image : '{{CASITA_INIT_IMAGE_NAME_TAG}}',
    command : ['npm', 'run', 'kafka']
  },{
    name : 'google-cloud-metrics',
    image : '{{CASITA_INIT_IMAGE_NAME_TAG}}',
    command : ['npm', 'run', 'google-cloud-metrics'],
  },{
    name : 'postgres',
    image : '{{CASITA_INIT_IMAGE_NAME_TAG}}',
    command : ['npm', 'run', 'postgres']
  }],
  "env" : [
    {"name": "GOOGLE_APPLICATION_CREDENTIALS", "value": "/etc/google/service-account.json"},
    {"name": "PG_DATABASE", "value": "casita"},
    {"name": "PG_HOST", "value": "postgres-service"},
    {"name": "MAX_WORKERS", "value": "72"},
    {"name": "DEFAULT_PARTITIONS", "value": "3"}
  ],
  volumes: [
    {
      "name": "service-account-key", 
      "hostPath": "casita-deployment/casita-local-dev/service-account.json",
      "type": "File",
      "mountPath": "/etc/google/service-account.json"
    }
  ]
})