BaseMapper = require "./base_mapper"

module.exports = class DocumentMapper extends BaseMapper

  dbPrefix: 'activities-state'
  views: 
    find_by_state_id:
      map: (doc) ->
        if (doc.type == "activities-state")
          emit(doc.value.stateId, doc.value)
    find_by_content:
      map: (doc) ->
        if (doc.type == "activities-state")
          emit(doc.value.content, doc.value)
    
  constructor: (@dbController, callback) ->
    super callback
  
  save: (document, callback, docType) ->
    object = 
      value: document
      type: "activities-state"

    @dbController.db.save object, (err, result) ->
      callback(err, result)
