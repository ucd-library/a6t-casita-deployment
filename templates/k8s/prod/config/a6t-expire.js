module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_A6T_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "a6t-expire",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run expire"],
  "env" : [
    {"name": "REDIS_HOST", "value": "redis-master"}
  ]
})