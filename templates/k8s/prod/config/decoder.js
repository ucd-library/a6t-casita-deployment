module.exports = config => ({
  "SERVICE_NAME" : "decoder",
  "COMMAND" : "bash",
  "ARGS" : ["-c", "npm run decoder"],
  "volumes": [
    {
      "name": "ssh-key", 
      "mountPath": "/root/ssh-key",
      "secretName": "decoder-ssh-key"
    },
    {
      "name": "service-account",
      "mountPath": "/etc/google",
      "secretName": "service-account"
    }
  ]
})