request = require 'supertest'
fs = require 'fs'

##
# start server
##
require '../app/main.coffee'

##
# server url
app = 'http://localhost:8080'

describe('GET /statements', ->
  it 'responds with error', ->
    request(app)
      .get('/statements')
      .expect(501)
)

describe('POST statement', ->
  it 'responds ok', (done) -> fs.readFile(
    'test/data/1.0.0/valid/statement/minimal-example-variants/minimal-no-id.json',
    (err, data) ->
      request(app)
        .post('/statements')
        .send(data)
        .expect(200, done)
        .end (err, res) ->
          done(err) if err? else done()
  )
)

#fs.readFile(
#  'test/data/1.0.0/valid/statement/minimal-example-variants/minimal-no-id.json',
#  (err, data) ->
#    request(app)
#      .post('/statements')
#      .send(data)
#      #.expect('Content-Type', /json/)
#      .expect(409)
#      .end (err, res) ->
#      throw err if err?
#)
