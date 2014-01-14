fs = require 'fs'
exampleStatements = require 'example_statements.coffee'
invalidStatements = 'test/data/1.0.0/invalid/statement/'
env = require 'setup_test_env'
    
describe 'POST an invalid statement', ->
  fs.readdir invalidStatements, (err, files) ->
    for file in files
      describe "from file: #{file}", ->
        it 'responds with 400 Bad Request', (done) ->
          fs.readFile invalidStatements + file, 'utf8', (err, data) ->
            if err
              console.log "error reading file '#{file}'. #{err}"
              done(err)
              return
            env.request
              .post('/statements')
              .set('Content-Type', 'application/json')
              .send(data)
              .expect(400, done)