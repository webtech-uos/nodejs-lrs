fs = require "fs"

##
#test header start
##
request = null
server = null
beforeEach (done) ->
  require('setup_test_env').prepareTest (err, serv, req) ->
    request = req
    server = serv
    done err

afterEach ->
  server.tearDown((->))
##
#test header end
##

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
