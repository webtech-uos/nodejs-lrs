fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'

describe 'POST', ->

  describe "a minimal valid statement that doesn't exist yet", ->
    it 'responds with 200 OK', (done) ->
      data = exampleStatements.minimalWithoutId
      env.request
        .post('/api/statements')
        .set('Content-Type', 'application/json')
        .send(data)
        .expect('x-experience-api-version', env.apiVersion)
        .expect(200, done)

  describe 'an identical statement with same ID', ->
    @timeout 20000
    it 'SHOULD respond with 200 OK', (done) ->
      env.factory.create undefined, (err, statement) ->
        return done err if err?
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(200, done)

  describe 'an identical statement with different ID', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      env.factory.create undefined, (err, statement) ->
        return done err if err?
        statement.id = '12345678-1234-5678-1234-567812345681'
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(200, done)

  describe 'a different statement with same ID', ->
    it 'SHOULD respond with 409 Conflict', (done) ->
      env.factory.create undefined, (err, statement) ->
        return done err if err?
        statement.actor.account.name = "Smith"
        env.request
          .post('/api/statements')
          .set('Content-Type', 'application/json')
          .send(statement)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(409, done)

  describe 'a GET request as a POST request instead', ->
    it 'MUST "differentiate a POST to add a Statement or to list Statements based on the parameters passed"'
