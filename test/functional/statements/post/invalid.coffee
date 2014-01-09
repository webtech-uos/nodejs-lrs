fs = require "fs"
require ('test_init')

##
# start server
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
