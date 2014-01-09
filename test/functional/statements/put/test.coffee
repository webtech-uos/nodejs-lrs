fs = require "fs"

##
# start server
##

request = null

beforeEach (done) ->
  require('setup_test_env').prepareTest (err, req) ->
    request = req
    done err
    
afterEach ->
  require('setup_test_env').tearDown()

exampleStatements = require "example_statements.coffee"

describe "PUT valid statement to /statements", ->

exampleStatements = require "example_statements.coffee"

describe "PUT valid statement to /statements", ->
  request = null
  it "responds with 204 No Content", (done) ->
    fs.readFile exampleStatements.minimalWithoutId, 'utf8', (err, data) ->
        request
          .put("/statements")
          .set('Content-Type', 'application/json')
          .send(data)
          .expect(204, done)
