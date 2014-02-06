fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'

describe 'PUT', ->
  describe 'valid statement ', ->
    it 'responds with 204 No Content', (done) ->
      data = exampleStatements.minimalWithoutId
      return done err if err?
      env.request
        .put('/api/statements')
        .type('application/json')
        .query(
          statementId: '12345678-1234-5678-1234-567812345681')
        .send(data)
        .expect('x-experience-api-version', env.apiVersion)
        .expect(204, done)

  describe 'a different statement with same ID', ->
    testCase = (minimalStatement, done) ->
      env.factory.create minimalStatement, (err, statement) ->
        return done err if err?
        statement.actor.mbox = "mailto:test@example.com"
        env.request
          .put('/api/statements')
          .type('application/json')
          .query(statementId: statement.id)
          .send(statement)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(409, done)
    it 'SHOULD respond with 409 Conflict', (done) ->
      testCase exampleStatements.minimalWithoutId, done
    it 'SHOULD respond with 409 Conflict', (done) ->
      testCase exampleStatements.minimalWithId, done
