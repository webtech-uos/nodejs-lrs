supertest = require "supertest"
fs = require "fs"

##
# start server
##
server = require "setup_server.coffee"
request = supertest server

exampleStatements = require "example_statements.coffee"

describe "POST", ->
  # TODO: this assumes the item doesn't exist, set up db accordingly
  describe "a minimal valid statement that doesn't exist yet", ->
    it "responds with 200 OK", (done) ->
      fs.readFile exampleStatements.minimalWithoutId, (err, data) ->
        request
          .post("/statements")
          .send(data)
          .expect(200, done)

  describe "a minimal valid statement that exists already", ->
    it "SHOULD respond with 200 OK", (done) ->
      fs.readFile exampleStatements.minimalWithoutId, (err, data) ->
        request
          .post("/statements")
          .send(data)
          .expect(200, done)
  #
  # FIXME: we can't rely on the first statement being saved before the second request
  # ("The LRS MAY respond before Statements that have been stored are available for retrieval.",
  # xAPI 1.0.0 spec)
  describe "a minimal valid statement with an ID that exists already", ->
    it "SHOULD respond with 409 Conflict", (done) ->
      fs.readFile exampleStatements.minimalWithId, (err, data) ->
        request
          .post("/statements")
          .send(data)
          .end done
        request
          .post("/statements")
          .send(data)
          .expect(409, done)
