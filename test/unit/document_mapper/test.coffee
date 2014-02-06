config = require '../../../app/config'
DBController = require '../../../app/model/database/db_controller'
DocumentMapper = require '../../../app/model/document_mapper'
assert = require 'assert'
util = require "util"

testDocument =
  stateId: 'testDocument'
  content: 'test'

describe.only 'DocumentMapper', ->
  
  documentMapper = null
  dbController = null
  
  before (done) ->
    config.database.name = 'nodejs-lrs-documentmapper-test'
    config.database.reset = true
    dbController = new DBController config.database, (err) ->
      documentMapper = new DocumentMapper(dbController, done)
  
  after (done) ->
    dbController.deleteDB done
    
  it 'should have method find_by_state_id', (done) ->
    if documentMapper.views.find_by_state_id?
      done()
    else
      done(new Error "Method find_by_state_id not found")

  it 'insert should not fail', (done) ->
    documentMapper.save(testDocument, done)

  it 'should return state document find by id', (done) ->
    documentMapper.views.find_by_state_id {key: "testDocument"}, (err, docs) ->
      if err?
        done new Error err.reason
      else
        try
          assert.deepEqual docs[0].value, testDocument
          done()
        catch err
          done err

  it 'should return state document find by content', (done) ->
    documentMapper.views.find_by_content {key: "test"}, (err, docs) ->
      if err?
        done new Error err.reason
      else
        try
          assert.deepEqual docs[0].value, testDocument
          done()
        catch err
          done err

  it 'should return document not found error', (done) ->
    documentMapper.views.find_by_state_id {key: 'jahsjd'}, (err, docs) ->
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