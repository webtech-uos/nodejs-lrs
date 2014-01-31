config = require '../../../app/config'
DBController = require '../../../app/model/database/db_controller'
DocumentMapper = require '../../../app/model/document_mapper'
assert = require 'assert'

testDocument =
  type: 'activity-state'
  value: 
    stateId: 'testDocument'
    content: 'test'

describe 'DocumentMapper', ->
  
  documentMapper = null
  dbController = null
  
  before (done) ->
    config.database.name = 'nodejs-lrs-documentmapper-test'
    config.database.reset = true
    dbController = new DBController config.database, (err) ->
      documentMapper = new DocumentMapper(dbController, done)

  after (done) ->
    dbController.deleteDB done

  it 'insert should not fail', (done) ->
    documentMapper.save(testDocument, done)

  it 'should return state document', (done) ->
    documentMapper.find 'testDocument', (err, docs) ->
      if err?
        done err
      else
        try
          assert.deepEqual docs[0].value, testDocument
          done()
        catch err
          done err

  it 'should return document not found error', (done) ->
    documentMapper.find 'jahsjd', (err, docs) ->
      if err?
        if err.httpCode is 404
          done()
        else
          done err
      else
        if docs.length isnt 0
          done new Error "Found document for non-existing stateId"
        else 
          done()