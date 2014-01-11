assert = require 'assert'
setup = require 'setup_test_env'
  

describe 'GET', ->

  describe '/statements', ->
    it 'responds with 200 OK', (done) ->
      setup done, (request) ->
        request
          .get('/statements')
          .expect(200, done)

    it 'has Content-Type: json', (done) ->
      setup done, (request) ->
        request
          .get('/statements')
          .expect('Content-Type', /json/, done)

    it 'has the required header fields', (done) ->
      setup done, (request) ->
        Validator = require '../../../../app/validator/validator.coffee'
        val = new Validator 'app/validator/schemas/'
  
        request
          .get('/statements')
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

  describe '/statements/id with a valid ID', ->
    it 'responds with 200 OK and a valid StatementResult'
  describe '/statements/id with an invalid ID', ->
    it 'responds with 404 Not Found'

# TODO: validate the returned statement
