winston = require 'winston'

module.exports = new (winston.Logger) transports: [
    new (winston.transports.Console)({ level: 'info' }),
    new (winston.transports.File)({ filename: 'log.txt' })
  ]