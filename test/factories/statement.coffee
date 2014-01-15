StatementMapper = require '../../app/model/statement_mapper'

counter = 0

module.exports = class StatementFactory
  
  constructor: (@dbController) ->
    @mappper = new StatementMapper @dbController
    
  create: (callback, modifier) ->
    statement = require '../data/1.0.0/valid/statement/minimal-example-variants/minimal-agent-account.json'
    if modifier
      modifier statement, (err) ->
        if err
          callback err
        else
          @mappper.save statement, callback
    else
      @mappper.save statement, callback