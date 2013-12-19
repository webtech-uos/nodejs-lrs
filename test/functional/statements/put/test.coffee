fs = require "fs"
request = require "supertest"

##
# start server
##
server = require "setup_server.coffee"

exampleStatements = require "example_statements.coffee"

request = request server

describe "PUT valid statement to /statements", ->
  it "responds with 204 No Content", (done) ->
    fs.readFile exampleStatements.minimalWithoutId, (err, data) ->
        request
          .put("/statements")
          .send(data)
          .expect(204, done)
