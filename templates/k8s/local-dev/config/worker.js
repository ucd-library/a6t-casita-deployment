module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "worker",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run worker"],
  // "ARGS" : ["-c", "tail -f /dev/null"],
  "env" : [
    {"name": "LOG_LEVEL", "value": "debug"}
  ]
});