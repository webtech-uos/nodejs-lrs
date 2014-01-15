# All configuration should be stored here.

module.exports =
  database: # couchDB
    host: 'localhost'
    port: 5984
    name: 'nodejs-lrs'
    reset: true
  server: # REST server (xAPI)
    port: 8080
    name: 'nodejs-lrs'
    version: '0.0.1'
  logger:
    file: 'log.txt'
    level: 'error'