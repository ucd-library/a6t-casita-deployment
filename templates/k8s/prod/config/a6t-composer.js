module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_A6T_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "a6t-composer",
  "COMMAND" : "bash",
  "replicas" : 3,
  "nodeSelector" : {
    "intendedfor" : "services",
  },
  "ARGS" : ["-c", "npm run composer"],
  "env" : [
    {"name": "REDIS_HOST", "value": "redis-master"}
    // {"name": "LOG_LEVEL", "value": "debug"}
  ]
})