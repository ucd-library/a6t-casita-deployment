module.exports = config => ({
  "SERVICE_NAME" : "decoder",
  "COMMAND" : "bash",
  // "ARGS" : ["-c", "/casita/services/nodejs/decoder/run.sh"]
  "ARGS" : ["-c", "tail -f /dev/null"],
  "env" : [
    {"name": "GRB_FILE", "value": "decoded"},
    {"name": "SSH_KEY_USERNAME", "value": "casita"}
  ],
  "volumes": [
    {
      "name": "ssh-key", 
      "hostPath": "casita-deployment/casita-local-dev/id_rsa",
      "type": "File",
      "mountPath": "/root/.ssh/id_rsa"
    }
  ]
})