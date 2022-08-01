module.exports = config => ({
  "SERVICE_NAME" : "grb-product-writer",
  "COMMAND" : "bash",
  "replicas" : 3,
  "nodeSelector" : {
    "intendedfor" : "services",
  },
  "env" : [
    {"name": "KAFKA_CLIENT_ID", "value": "grb-product-writer"}
  ],
  "ARGS" : ["-c", "npm run product-writer"]
});