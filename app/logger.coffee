winston = require 'winston'
config = require('./config').logger

# Winston is capable of loggin both to console and file.
# This logger will report any message on console and should be used application-wide.

module.exports = new (winston.Logger) transports: [
    new (winston.transports.Console)({ level: config.level }),
    new (winston.transports.File)({ filename: config.file })
  ]
