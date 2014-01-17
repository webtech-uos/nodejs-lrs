fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'
StatementFactory = require '../../../factories/statement'

describe 'PUT', ->
  describe 'valid statement ', ->
    it 'responds with 204 No Content', (done) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        return done err if err?
        env.request
          .put('/api/statements')
          .type('application/json')
          .query(
            statementId: '12345678-1234-5678-1234-567812345681')
          .send(data)
          .expect(204, done)

  describe 'a different statement with same ID', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      factory = new StatementFactory env.dbController
      minimalStatement = exampleStatements.minimalWithId
      factory.create minimalStatement, (err, statement) ->
        # FIXME: someone is throwing empty objects around here?
        return done err if err?
        statement.actor.mbox = "mailto:test@example.com"
        env.request
          .put('/api/statements')
          .type('application/json')
          .query(statementId: statement.id)
          .send(statement)
          .expect(409, done)
