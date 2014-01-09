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

invalidStatements = "test/data/1.0.0/invalid/statement/"

fs.readdir invalidStatements, (err, files) ->
  for file in files
    describe "POST an invalid statement", ->

      describe "from file: #{file}", ->
        it "responds with 400 Bad Request", (done) ->
          fs.readFile invalidStatements + file, 'utf8', (err, data) ->
            if err
              console.log "error reading file '#{file}'. #{err}"
              done(err)
              return
            request
              .post("/statements")
              .set('Content-Type', 'application/json')
              .send(data)
              .expect(400, done)
