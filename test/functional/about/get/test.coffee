assert = require 'assert'
env = require 'setup_test_env'

describe 'GET /api/about', ->
  describe 'Returns JSON Object containing information about this LRS, including the xAPI version supported', ->
    it 'should respond with 200 OK', (done) ->
      env.request
        .get('/api/about')
        .expect('content-type', /json/)
        .expect('x-experience-api-version', env.apiVersion)
        .expect(200, done)