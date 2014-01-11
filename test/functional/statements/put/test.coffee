fs = require 'fs'
setup = require 'setup_test_env'
exampleStatements = require 'example_statements.coffee'

describe 'PUT valid statement to /statements', ->

  it 'responds with 204 No Content', (done) ->
    setup done, (request) ->
      fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
          request
            .put('/statements')
            .set('Content-Type', 'application/json')
            .send(data)
            .expect(204, done)
