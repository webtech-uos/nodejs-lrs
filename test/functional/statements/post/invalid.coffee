fs = require 'fs'
invalidStatements = 'test/data/1.0.0/invalid/statement/'
env = require 'setup_test_env'

describe 'POST an invalid statement', ->
  fs.readdir invalidStatements, (err, files) ->
    for file in files
      describe "from file: #{file}", ->
        it 'responds with 400 Bad Request', (done) ->
          fs.readFile invalidStatements + file, 'utf8', (err, data) ->
            return done err if err?
            env.request
              .post('/api/statements')
              .set('Content-Type', 'application/json')
              .send(data)
              .expect('x-experience-api-version', '1.0.0')
              .expect(400, done)
