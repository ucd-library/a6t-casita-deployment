module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "casita-worker",
  "COMMAND" : "bash",
  // "ARGS" : ["-c", "cd /service && node init"]
  "ARGS" : ["-c", "tail -f /dev/null"]
});