module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "worker",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run worker"],
  "K8S_DEPLOYMENT_CPU" : "400m",
  "nodeSelector" : {
    "intendedfor" : "worker",
  },
  "env" : [
    {"name": "KAFKA_CLIENT_ID", "value": "worker"}
    // {"name": "LOG_LEVEL", "value": "debug"}
  ]
});