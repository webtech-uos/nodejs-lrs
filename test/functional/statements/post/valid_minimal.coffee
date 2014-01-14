fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
env = require 'setup_test_env'

describe 'POST', ->
    
  # FIXME: You dont know which of these tests is finished first.
  #        Does it matter?
  #        Only in terms of provided descriptions.  
  # TODO: this assumes the item doesn't exist, set up db accordingly
  describe "a minimal valid statement that doesn't exist yet", ->
    it 'responds with 200 OK', (done) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        env.request
          .post('/statements')
          .set('Content-Type', 'application/json')
          .send(data)
          .expect(200, done)

  # FIXME: this assumes the item DOES exist
  describe 'a minimal valid statement that exists already', ->
    it 'SHOULD respond with 200 OK', (done) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        env.request
          .post('/statements')
          .set('Content-Type', 'application/json')
          .send(data)
          .expect(200, done)

  describe 'a minimal valid statement with an ID that exists already', ->
    it 'SHOULD respond with 409 Conflict'
