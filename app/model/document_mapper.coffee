BaseMapper = require "./base_mapper"
logger = require '../logger'

module.exports = class DocumentMapper extends BaseMapper

  @TYPE = 'activities-state'

  @VIEWS =
    find_by_state:
      map: (doc) ->
        if (doc.type is 'activities-state')
          emit(doc.value.stateId, doc.value)
    find_by_content:
      map: (doc) ->
        if (doc.type is 'activities-state')
          emit(doc.value.content, doc.value)

  find: (id, callback) ->
    @views.find_by_state key: id, (err, docs) ->
      search = id
      if err
        callback err, []
      else 
        switch docs.length
          when 0
            callback 'DocumentMapper.find: Failed to find State for given ID', []
          when 1
            logger.info 'DocumentMapper.find: Successfully found State'
            state = docs[0].value
            callback undefined, state
          else
            callback 'DocumentMapper.find: Multiple States for Id', []
