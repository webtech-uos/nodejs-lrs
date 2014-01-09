fs = require "fs"

##
# start server
##
exampleStatements = require "example_statements.coffee"

invalidStatements = "test/data/1.0.0/invalid/statement/"

fs.readdir invalidStatements, (err, files) ->
  for file in files
    describe "POST an invalid statement", ->

      request = null
      beforeEach (done) ->
        require('setup_server').prepareTest (err, req) ->
          request = req
          done err

      describe "from file: #{file}", ->
        it "responds with 400 Bad Request", (done) ->
          fs.readFile 'utf-8', invalidStatements + file, (err, data) ->
            if err
              console.log "error reading file '#{file}'. #{err}"
              done(err)
              return
            request
              .post("/statements")
              .set('Content-Type', 'application/json')
              .send(data)
              .expect(400, done)
