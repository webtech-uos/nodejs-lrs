assert = require "assert"

describe "GET", ->

  request = null

  describe "/statements", ->
    it "responds with 200 OK", (done) ->
      request
        .get("/statements")
        .expect(200, done)

    it "has Content-Type: json", (done) ->
      request
        .get("/statements")
        .expect("Content-Type", /json/, done)

    it "has the required header fields", (done) ->
      request
        .get("/statements")
        #TODO validate these fields
        .end (err, res) ->
          if err?
            done(err)
          for header in ["X-Experience-API-Consistent-Through"]
            assert header of res?.headers,
              "has #{header} header"

  describe "/statements/id with a valid ID", ->
    it "responds with 200 OK and a valid StatementResult"
  describe "/statements/id with an invalid ID", ->
    it "responds with 404 Not Found"

# TODO: validate the returned statement
