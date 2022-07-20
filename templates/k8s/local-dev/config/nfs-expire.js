module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "nfs-expire",
  "COMMAND" : "bash",
  // "ARGS" : ["-c", "npm run expire"]
  "ARGS" : ["-c", "tail -f /dev/null"]
});