BaseMapper = "../../app/model/base_mapper"
config = require '../../../app/config'
DBController = require '../../../app/model/database/db_controller'
assert = require 'assert'

describe.skip 'BaseMapper', ->
  
  base_mapper = null
  dbController = null
  
  before (done) ->
    config.database.name = 'nodejs-lrs-basemapper-test'
    config.database.reset = true
    dbController = new DBController config.database, (err) ->
      base_mapper = new BaseMapper(dbController, done)
      #base_mapper.dbPrefix = 
      base_mapper.views = 
        "find_by_stateId":
          map: (doc) ->
            if (doc.type == "activity-state")
              emit(doc.value.value.stateId, doc.value)

  after (done) ->
    dbController.deleteDB done

  it 'insert should not fail', (done) ->
    documentMapper.save(testDocument, done)
