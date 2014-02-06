StatementMapper = require '../../app/model/statement_mapper'

counter = 0

module.exports = class StatementFactory

  constructor: (@dbController, callback) ->
    @mapper = new StatementMapper @dbController, callback


  # save a (possibly modified) statement to the database, then execute the callback
  #
  # the modifier is an object that is used to either
  # - modify parts of the statement by overwriting a field with a new value or
  # - calling the supplied callback with an additional statement counter
  #   the corresponding value and the whole statement
  create: (modifier, callback) ->
    # create a deep copy to avoid caching by require
    statement = JSON.parse JSON.stringify require '../data/1.0.0/valid/statement/minimal-example-variants/minimal-agent-account.json'
    for key, value of modifier
      if typeof value == 'function'
        value counter statement[key] statement
      else
        statement[key] = value

    @mapper.save statement, callback

    counter++
