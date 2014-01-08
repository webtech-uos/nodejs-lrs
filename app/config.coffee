module.exports =
  database: # couchDB
    host: 'localhost'
    port: 5984
    name: 'nodejs-lrs'
    reset: false
  server: # REST server (xAPI)
    port: 8080
    name: 'nodejs-lrs'
    version: '0.0.1'

