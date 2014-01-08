Server = require './server'

new Server require('./config'), (err) ->
  if err
    console.log 'CRITICAL ERROR, BYE!'
    process.exit()
  else
    console.log 'SERVER IS UP AND RUNNING'