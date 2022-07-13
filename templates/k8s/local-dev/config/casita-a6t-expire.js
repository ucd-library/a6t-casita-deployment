module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_A6T_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "casita-a6t-expire",
  "COMMAND" : "bash",
  // "ARGS" : ["-c", "node composer/expire.js"]
  "ARGS" : ["-c", "tail -f /dev/null"],
  "env" : [
    {"name": "REDIS_HOST", "value": "redis-master"}
  ],
  "volumes": [
    {
      "name": "composer-local-dev", 
      "hostPath": "argonaut/expire",
      "mountPath": "/service/expire"
    },
    {
      "name": "composer-utils-local-dev", 
      "hostPath": "argonaut/utils",
      "mountPath": "/service/utils"
    }
  ]
})