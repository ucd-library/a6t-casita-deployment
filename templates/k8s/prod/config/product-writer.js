module.exports = config => ({
  "SERVICE_NAME" : "grb-product-writer",
  "COMMAND" : "bash",
  "replicas" : 3,
  "nodeSelector" : {
    "intendedfor" : "services",
  },
  "ARGS" : ["-c", "npm run product-writer"]
});