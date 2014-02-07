BaseMapper = require "./base_mapper"

module.exports = class DocumentMapper extends BaseMapper

  @TYPE = 'activities-state'

  @VIEWS =
    find_by_state_id:
      map: (doc) ->
        if (doc.type is 'activities-state')
          emit(doc.value.stateId, doc.value)
    find_by_content:
      map: (doc) ->
        if (doc.type is 'activities-state')
          emit(doc.value.content, doc.value)