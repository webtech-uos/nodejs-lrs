fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'
StatementFactory = require '../../../factories/statement'

describe 'POST', ->

  describe "a minimal valid statement that doesn't exist yet", ->
    it 'responds with 200 OK', (done) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        return done err if err?
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(data)
          .expect('x-experience-api-version', '1.0.0')
          .expect(200, done)

  describe 'an identical statement with same ID', ->
    @timeout 20000
    it 'SHOULD respond with 200 OK', (done) ->
      factory = new StatementFactory env.dbController
      factory.create undefined, (err, statement) ->
        return done err if err?
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', '1.0.0')
          .expect(200, done)

  describe 'an identical statement with different ID', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      factory = new StatementFactory env.dbController
      factory.create undefined, (err, statement) ->
        return done err if err?
        statement.id = '12345678-1234-5678-1234-567812345681'
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', '1.0.0')
          .expect(200, done)

  describe 'a different statement with same ID', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      factory = new StatementFactory env.dbController
      factory.create undefined, (err, statement) ->
        return done err if err?
        #statement.id = '12345678-1234-5678-1234-567812345681'
        statement.actor.account.name = "Smith"
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', '1.0.0')
          .expect(409, done)

  describe 'a GET request as a POST request instead', ->
    it 'MUST "differentiate a POST to add a Statement or to list Statements based on the parameters passed"'
