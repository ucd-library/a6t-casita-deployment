module.exports = config => ({
  "SERVICE_NAME" : "product-writer",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "node /casita/services/nodejs/goes-product-writer/index.js"]
  // "ARGS" : ["-c", "tail -f /dev/null"]
});