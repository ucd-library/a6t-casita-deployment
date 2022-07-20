module.exports = config => ({
  "CASITA_IMAGE_NAME_TAG" : "{{CASITA_IMAGE_NAME}}:{{APP_VERSION}}",
  "SERVICE_NAME" : "rest",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run rest"],
  // "ARGS" : ["-c", "tail -f /dev/null"]
});