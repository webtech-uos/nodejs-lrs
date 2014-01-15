fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'
StatementFactory = require '../../../factories/statement'

describe 'POST', ->

  describe "a minimal valid statement that doesn't exist yet", ->
    it 'responds with 200 OK', (done) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        env.request
          .post('/statements')
          .set('Content-Type', 'application/json')
          .send(data)
          .expect(200, done)


  describe 'a minimal valid statement that exists already', ->
    @timeout 20000
    it 'SHOULD respond with 200 OK', (done) ->
      factory = new StatementFactory env.dbController
      factory.create (err, statement) ->
        if err
          done(err) 
        else
          env.request
            .post('/statements')
            .set('Content-Type', 'application/json')
            .send(statement)
            .expect(200, done)

  describe 'a minimal valid statement with an ID that exists already', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      factory = new StatementFactory env.dbController
      factory.create (err, statement) ->
        if err
          done(err) 
        else
          statement.object.id += 'this-is-different'
          env.request
            .post('/statements')
            .set('Content-Type', 'application/json')
            .send(statement)
            .expect(409, done)
