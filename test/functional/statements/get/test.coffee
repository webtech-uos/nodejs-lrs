request = require "supertest"

##
# start server
##
server = require "setup_server.coffee"


describe "GET", ->
  describe "/statements", ->
    it "responds with 200 OK", (done) ->
      request(server)
        .get("/statements")
        .expect(200)
        .expect('Content-Type', /json/)
        # ISO 8601 regex cf.
        # http://www.pelagodesign.com/blog/2009/05/20/iso-8601-date-validation-that-doesnt-suck/
        .expect('X-Experience-API-Consistent-Through',
          /^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/
        )
        .end (err, res) ->
          done(err) if err? else done()
  describe "/statements/id with a valid ID", ->
    it "responds with 200 OK and a valid StatementResult"
  describe "/statements/id with an invalid ID", ->
    it "responds with 404 Not Found"

# TODO: validate the returned statement
