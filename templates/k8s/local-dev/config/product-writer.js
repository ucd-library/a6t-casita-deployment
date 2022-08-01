module.exports = config => ({
  "SERVICE_NAME" : "grb-product-writer",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run product-writer"]
  // "ARGS" : ["-c", "tail -f /dev/null"]
});