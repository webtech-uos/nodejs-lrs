assert = require 'assert'
env = require 'setup_test_env'
StatementFactory = require '../../../factories/statement'
_ = require 'underscore'

describe 'GET', ->
  describe '/api/statements', ->
    it 'responds with 200 OK', (done) ->
        env.request
          .get('/api/statements')
          .expect(200, done)

    it 'has Content-Type: json', (done) ->
      env.request
        .get('/api/statements')
        .expect('Content-Type', /json/, done)

    it 'has the required header fields', (done) ->
      Validator = require '../../../../app/validator/validator.coffee'
      val = new Validator 'app/validator/schemas/'

      env.request
        .get('/api/statements')
        .end (err, res) ->
          return done err if err?

          consistent = 'X-Experience-API-Consistent-Through'
          assert consistent.toLowerCase() of res?.headers,
              "has #{consistent} header"
          val.validateWithSchema res?.headers['x-experience-api-consistent-through'],
            'ISO8061Date',
            done

  describe '/api/statements/id with a valid ID', ->
    it 'responds with 200 OK and a valid StatementResult', (done) ->
      factory = new StatementFactory env.dbController
      factory.create undefined, (err, statement) ->
        return done err if err?
        env.request
          .get("/api/statements/#{statement.id}")
          .expect('Content-Type', /json/)
          .expect(200)
          .end (err, res) ->
            return done err if err?
            err ?= 'statements do not match' unless _.isEqual statement, res.body
            done err

  describe 'api/statements/id with an invalid ID', (done) ->
    it 'responds with 404 Not Found', ->
      env.request
        .get('/api/statements/this-id-does-not-exist')
          .expect(404, done)
