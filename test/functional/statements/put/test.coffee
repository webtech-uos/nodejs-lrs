fs = require "fs"

##
# start server
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
