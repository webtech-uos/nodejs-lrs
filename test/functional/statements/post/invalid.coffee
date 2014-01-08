fs = require "fs"

##
# start server
##
exampleStatements = require "example_statements.coffee"

invalidStatements = "test/data/1.0.0/invalid/statement/"

require("setup_server.coffee").prepareTest (request) ->
  fs.readdir invalidStatements, (err, files) ->
    for file in files
      describe "POST an invalid statement", ->
        describe "from file: #{file}", ->
          it "responds with 400 Bad Request", (done) ->
            fs.readFile invalidStatements + file, (err, data) ->
              if err
                console.log "error reading file '#{file}'. #{err}"
                done(err)
                return
              request
                .post("/statements")
                .send(data)
                .expect(400, done)
