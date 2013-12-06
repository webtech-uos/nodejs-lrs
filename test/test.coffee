request = require 'supertest'
fs = require 'fs'

app = 'http://localhost:8080/statements'

request(app)
  .get('/statements')
  .expect('Content-Type', /json/)
  .expect(200)
  .end (err, res) ->
    throw err if err?

fs.readFile(
  'test/data/1.0.0/valid/statement/minimal-example-variants/minimal-no-id.json',
  (err, data) ->
    request(app)
      .post('/statements')
      .send(data)
      #.expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) ->
      throw err if err?
)

fs.readFile(
  'test/data/1.0.0/valid/statement/minimal-example-variants/minimal-no-id.json',
  (err, data) ->
    request(app)
      .post('/statements')
      .send(data)
      #.expect('Content-Type', /json/)
      .expect(409)
      .end (err, res) ->
      throw err if err?
)
