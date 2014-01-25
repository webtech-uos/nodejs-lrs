StatementMapper = require '../../app/model/statement_mapper'

counter = 0

module.exports = class StatementFactory

  constructor: (@dbController, callback) ->
    @mapper = new StatementMapper @dbController, (err) =>
      callback(err)

  create: (
    statementPath = 'test/data/1.0.0/valid/statement/minimal-example-variants/minimal-agent-account.json',
    callback,
    modifier) ->
    statement = require "../../#{statementPath}"
    if modifier?
      modifier statement, (err) ->
        if err
          callback err
        else
          @mapper.save statement, callback
    else
      @mapper.save statement, callback
