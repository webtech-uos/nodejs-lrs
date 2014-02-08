assert = require 'assert'
env = require 'setup_test_env'
exampleStatements = require 'example_statements.coffee'
_ = require 'underscore'
utils = require '../../../../app/utils'

describe 'GET /api/statements', ->
  Validator = require '../../../../app/validator/validator.coffee'
  val = new Validator 'app/validator/schemas/'

  describe 'with no parameters', ->
    it 'should respond with 200 OK', (done) ->
      env.request
        .get('/api/statements')
        .expect('content-type', /json/)
        .expect('x-experience-api-version', env.apiVersion)
        .expect(200, done)

    it 'should respond with 200 OK if requested api version is "1.0"', (done) ->
      env.request
        .get('/api/statements')
        .set('x-experience-api-version', '1.0')
        .expect('content-type', /json/)
        .expect('x-experience-api-version', env.apiVersion)
        .expect(200, done)

    # TODO if we can fully support lower versions, change this test case
    it 'should reject the request if requested api version is < "1.0.0"', (done) ->
      env.request
        .get('/api/statements')
        .set('x-experience-api-version', '0.9.5')
        .expect('x-experience-api-version', env.apiVersion)
        .expect(400, done)

    it 'should reject the request if requested api version is >= "1.1.0"', (done) ->
      env.request
        .get('/api/statements')
        .set('x-experience-api-version', '2.5.1')
        .expect('x-experience-api-version', env.apiVersion)
        .expect(400, done)

    it 'should have the required header fields', (done) ->
      env.request
        .get('/api/statements')
        .expect('x-experience-api-version', env.apiVersion)
        .end (err, res) ->
          return done err if err?

          try
            consistent = 'x-experience-api-consistent-through'
            assert consistent in (x.toLowerCase() for x of res?.headers),
                "has #{consistent} header"
          catch err
            return done err

          val.validateWithSchema res?.headers['x-experience-api-consistent-through'],
            'ISO8061Date',
            done

  describe 'with an existing, valid statementId', ->
    it 'should return a valid StatementResult', (done) ->
      env.factory.create exampleStatements.minimalWithId, (err, statement) ->
        return done err if err?
        env.request
          .get('/api/statements')
          .query(statementId: statement.id)
          .expect('Content-Type', /json/)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(200)
          .end (err, res) ->
            return done err if err?
            err ?= new Error 'statements do not match' unless _.isEqual statement, res.body
            done err

  describe 'with a statementId', ->
    describe.skip 'when also supplied with voidedStatementId', ->
      it 'MUST reject the request with 400 Bad Request', ->
        env.factory.create undefined, (err, statement) ->
          return done err if err?
          env.request
            .get('/api/statements')
            .query(statementId: statement.id)
            .query(voidedStatementId: utils.generateUUID())
            .expect('x-experience-api-version', env.apiVersion)
            .expect(400, done)
    describe 'when also supplied with parameters other than "attachments" or "format"', ->
      it 'MUST reject the request with 400 Bad Request', (done) ->
        env.request
          .get('/api/statements')
          .query(statementId: '12345678-1234-5678-1234-567812345681')
          .query(until: 'foobar')
          .expect('x-experience-api-version', env.apiVersion)
          .expect(400, done)
    describe 'with a malformed statementId', ->
      it 'should respond with 400 Bad Request', (done) ->
        env.request
          .get('/api/statements')
          .query(statementId: 'this-is-not-even-a-valid-uuid')
          .expect('x-experience-api-version', env.apiVersion)
          .expect(400, done)
    describe 'with a valid, but nonexisting statementId', ->
      it 'should respond with 404 Not Found', (done) ->
        env.request
          .get('/api/statements')
          .query(statementId: '12345678-1234-5678-1234-567812345681')
          .expect('x-experience-api-version', env.apiVersion)
          .expect(404, done)

  describe 'with voided statements', ->
    # statement modifiers
    makeVoided = id: '12345678-1234-5678-1234-567812345681'
    makeVoiding =
      id: utils.generateUUID()
      verb:
        id: 'http://adlnet.gov/expapi/verbs/voided'
        display:
          'en-US': 'voided'
      object:
        id: '12345678-1234-5678-1234-567812345681'
        objectType: 'StatementRef'

    it 'MUST not return any Statement which has been voided', (done) ->
      env.factory.create makeVoided, (err, voided) ->
        return done err if err?
        env.factory.create makeVoiding, (err, voiding) ->
        env.request
          .get('/api/statements')
          .query(statementId: '12345678-1234-5678-1234-567812345681')
          .expect('x-experience-api-version', env.apiVersion)
          .expect(404, done)
    it 'unless that Statement has been requested by voidedStatementId.', (done) ->
      env.factory.create makeVoided, (err, voided) ->
        return done err if err?
        env.factory.create makeVoiding, (err, voiding) ->
        env.request
          .get('/api/statements')
          .query(voidedStatementId: '12345678-1234-5678-1234-567812345681')
          .expect('Content-Type', /json/)
          .expect('x-experience-api-version', env.apiVersion)
          .expect(200, done)
    describe 'with a statement targetting a voided statement', ->
      it 'MUST still return any Statements targetting the voided Statement'
      it 'MUST be able to return the voiding Statement, which cannot be voided', (done) ->
        env.factory.create makeVoided, (err, voided) ->
          return done err if err?
          env.factory.create makeVoiding, (err, voiding) ->
            env.request
              .get('/api/statements')
              .query(statementId: voiding.id)
              .expect('Content-Type', /json/)
              .expect('x-experience-api-version', env.apiVersion)
              .expect(200, done)
    describe 'when also supplied with parameters other than "attachments" or "format"', ->
      it 'MUST reject the request with 400 Bad Request', (done) ->
        env.request
          .get('/api/statements')
          .query(voidedStatementId: '12345678-1234-5678-1234-567812345681')
          .query(until: 'foobar')
          .expect('x-experience-api-version', env.apiVersion)
          .expect(400, done)

  # most of these parameters only apply for GETting multiple statements at once, see test suites above
  describe 'with agent parameter', ->
    it 'should return only "Statements for which the specified Agent or group is the Actor or Object of the Statement"'

  describe 'with verb parameter', ->
    it 'should return only "Statements matching the specified verb id"'

  describe 'with activity parameter', ->
    it 'should return only "Statements for which the Object of the Statement is an Activity with the specified id"'

  describe 'with registration parameter', ->
    it 'should return only "Statements matching the specified registration id."'

  describe 'with related_activities parameter', ->
    it 'should return only "Statements for which the Object, any of the context Activities, or any of those properties in a contained SubStatement match"'

  describe 'with related_agents parameter', ->
    it 'should return only "Statements for which the Actor, Object, authority, instructor, team, or any of these properties in a contained SubStatement match"'

  describe 'with since parameter', ->
    it 'should return only "Statements stored since the specified timestamp (exclusive)"'

  describe 'with until parameter', ->
    it 'should return only "Statements stored at or before the specified timestamp"'

  describe 'with limit parameter', ->
    it 'should return no more than the specified number of statements'
    it 'should use the server limit of statements if limit is 0'

  describe 'with format parameter', ->
    describe 'equal to "ids"', ->
      it 'should accept the value'
      it 'should "only include minimum information necessary in Agent, Activity, and group Objects to identify them"'
    describe 'equal to "exact"', ->
      it 'should accept the value'
      it 'should "return Agent, Activity, and group Objects populated exactly as they were when the Statement was received"'
    describe 'equal to "canonical"', ->
      it 'should accept the value'
      it 'should "return Activity Objects populated with the canonical definition of the Activity Objects as determined by the LRS"'
    it 'should reject invalid values'

  describe 'with attachments parameter', ->
    describe 'equal to "true"', ->
      it '"MUST use the multipart response format"'
      it '"MUST include all attachments as described in 4.1.11. Attachments"'
    describe 'equal to "false"', ->
      it '"MUST NOT include attachment raw data"'
      it '"MUST send the prescribed response with Content-Type application/json"'

  describe 'with ascending parameter', ->
   describe 'equal to "true"', ->
     it 'should "return results in ascending order of stored time"'
