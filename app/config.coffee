# All configuration should be stored here.

module.exports =
  version: '0.0.1'
  database: # couchDB
    host: 'localhost'
    port: 5984
    name: 'nodejs-lrs'
    reset: true
  server: # REST server (xAPI)
    port: 8080
    name: 'nodejs-lrs'
    xApiVersion: '1.0.0'
    oauth: false
    routePrefix: '/api'
  logger:
    file: 'log.txt'
    level: 'error'
