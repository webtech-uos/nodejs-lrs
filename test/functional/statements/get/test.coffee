assert = require "assert"

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

describe "GET", ->
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
      Validator = require "../../../../app/validator/validator.coffee"
      val = new Validator 'app/validator/schemas/'

      request
        .get("/statements")
        .end (err, res) ->
          if err?
            done(err)
          consistent = 'X-Experience-API-Consistent-Through'
          #FIXME Why are headers lowercase?
          assert consistent.toLowerCase() of res?.headers,
              "has #{consistent} header"
          val.validateWithSchema res?.headers['x-experience-api-consistent-through'],
            'ISO8061Date',
            done

  describe "/statements/id with a valid ID", ->
    it "responds with 200 OK and a valid StatementResult"
  describe "/statements/id with an invalid ID", ->
    it "responds with 404 Not Found"

# TODO: validate the returned statement
