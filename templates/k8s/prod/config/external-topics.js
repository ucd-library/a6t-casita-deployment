module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "external-topics",
  "COMMAND" : "bash",
  "nodeSelector" : {
    "intendedfor" : "services",
  },
  "ARGS" : ["-c", "npm run external-topics"]
});