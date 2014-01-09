# Launches the LRS
# with the paramters defined in `config.coffee`

Server = require './server'
logger = require './logger'

new Server require('./config'), (err) ->
  if err
    logger.error 'CRITICAL ERROR, BYE!'
    process.exit()
  else
    logger.info 'SERVER IS UP AND RUNNING'