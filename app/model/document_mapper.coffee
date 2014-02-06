BaseMapper = require "./base_mapper"

module.exports = class DocumentMapper extends BaseMapper

  dbPrefix: 'activities-state'
  views: 
    find_by_state_id:
      map: (doc) ->
        if (doc.type == "activities-state")
          emit(doc.value.stateId, doc.value)
    
  constructor: (@dbController, callback) ->
    super callback
  
  save: (document, callback, docType) ->
    object = 
      value: document
      type: "activities-state"

    @dbController.db.save object, (err, result) ->
      callback(err, result)

  # findById: (stateId, callback) ->
  #   @dbController.db.view '#{@dbPrefix}/find_by_stateId', key: stateId, (err, docs) ->
  #     if err?
  #       callback err
  #     else
  #       if docs.length == 0
  #         err = new Error "Document not found"
  #         err.httpCode = 404
  #         callback err
  #         return
  #       else
  #         callback null, docs