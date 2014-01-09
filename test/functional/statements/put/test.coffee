fs = require "fs"

##
# start server
##
exampleStatements = require "example_statements.coffee"

describe "PUT valid statement to /statements", ->
  
  request = null
  beforeEach (done) ->
    require('setup_server').prepareTest (err, req) ->
      request = req
      done err
  
  it "responds with 204 No Content", (done) ->
    fs.readFile exampleStatements.minimalWithoutId, (err, data) ->
        request
          .put("/statements")
          .set('Content-Type', 'application/json')
          .send(data.toString())
          .expect(204, done)