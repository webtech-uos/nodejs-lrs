winston = require 'winston'

# Winston is capable of loggin both to console and file.
# This logger will report any message on console and should be used application-wide.

module.exports = new (winston.Logger) transports: [
    new (winston.transports.Console)({ level: 'error' }),
    new (winston.transports.File)({ filename: 'log.txt' })
  ]
