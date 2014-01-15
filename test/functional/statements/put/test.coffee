fs = require 'fs'
env = require 'setup_test_env'
exampleStatements = require 'example_statements.coffee'

describe 'PUT valid statement to /statements', ->

  it 'responds with 204 No Content', (done) ->
    fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
      env.request
        .put('/api/statements')
        .set('Content-Type', 'application/json')
        .send(data)
        .expect(204, done)