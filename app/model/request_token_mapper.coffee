logger = require '../logger'
_ = require 'underscore'
utils = require '../utils'

# Provides operations for all request tokens on top
# of CouchDB.
#
module.exports = class RequestMapper


  # Instanciates a new request token mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (@dbController, callback) ->
    viewFindBy =
      db_id:
        map: (doc)->
          if doc.type == 'RequestToken'
            emit doc._id, doc.value
          else
            emit null, null
      id:
        map: (doc)->
          if doc.type == 'RequestToken'
            emit doc.value.id, doc.value
          else
            emit null, null
      name:
        map: (doc) ->
          if doc.type == 'RequestToken'
            emit doc.value.name, doc.value
          else
            emit null, null

    viewList =
      db_ids:
        map: (doc)->
          if doc.type == 'RequestToken'
            emit doc._id, null
          else
            emit null, null

    viewCounter =
      all_request_tokens:
        map: (doc)->
          if doc.type == 'RequestToken'
            emit null, 1
          else
            emit null, 0
        reduce: (key, values, rereduce)->
          sum values

    views = []
    views.push '_design/find_request_token_by' : viewFindBy
    views.push '_design/request_token_list' : viewList
    views.push '_design/request_token_counter' : viewCounter

    counter = 0

    for view in views
      viewName = Object.keys(view)[0]
      viewObject = view[viewName]
      db = @dbController.db
      do(viewName, viewObject)->
        db.save viewName, viewObject, (err, res) =>
          if err
            logger.error "error while adding views into the database."
            logger.error err
            callback(err)
          else
            logger.info "inserted view #{viewName} into the database."
            counter++
            if counter == views.length
              callback()

  # Returns all stored statements to the callback.
  #
  # TODO: one should be able to specify the maximum number of returned statements
  #
  getAll: (callback) ->
    #TODO
    startIndex = null
    maxNumberStatements = 100
    numberRequested = maxNumberStatements

    @dbController.db.view 'counter/all_statements', (err, count) =>
      if err
        logger.error "getALL: database access with view counter/all_statements failed: #{JSON.stringify err}"
        callback err, []
      else if count.length > 0 # TODO
        scount = count[0].value
        if scount > numberRequested
          @dbController.db.view 'list/db_ids', descending: true, (err,  ids) =>
            if err
              logger.error "getALL: database access with list/statement_ids failed: #{JSON.stringify err}"
              callback err, []
            else
              startIndex = 0 unless startIndex

              if startIndex > scount
                callback {code: 400, message: 'More statements requested as there are'}
              else
                if startIndex + numberRequested < scount
                  endIndex = startIndex + numberRequested - 1
                  # TODO generate URI for more statements
                else
                  endIndex = scount - 1

                filterRange =
                  startkey : ids[startIndex].key
                  endkey: ids[endIndex].key
                  descending: true

                @dbController.db.view 'find_statement_by/db_id', filterRange, (err, docs) =>
                  if err
                    logger.error "getALL: database access with view find_statement_by/db_id failed: #{JSON.stringify err}"
                    callback err, []
                  else
                    statements = []
                    for doc in docs
                      statements.push doc.value

                    callback undefined, statements

        else
          @dbController.db.view 'find_statement_by/id', (err, docs) =>
            if err
              logger.error "getALL: database access with view find_statement_by/id failed: #{JSON.stringify err}"
              callback err, []
            else
              statements = []
              for doc in docs
                statements.push doc.value

              callback undefined, statements
      else
        #there are no statements in the db
        callback undefined, []
  # Returns the statement with the given id to the callback.
  #
  # @param id
  #   id of the statement to look up
  #
  find: (id, callback) ->
    @validator.validateWithSchema id, 'UUID', (err) =>
      if err
        callback { code: 400, message: 'Invalid UUID supplied!' }
      else
        @dbController.db.view 'find_statement_by/id', key: id, (err, docs) =>
          if err
            logger.error 'find statement: ' + id
            logger.error "find: database access with view find_statement_by/id failed: #{JSON.stringify err}"
            callback err, []
          else
            switch docs.length
              when 0
                logger.info 'statement does not exist: ' + id
                # there is no statement with the given id
                # TODO callback ERROR, null
                callback undefined
              when 1
                logger.info 'statement found: ' + id
                # all right, one statement found
                statement = docs[0].value
                callback undefined, statement
              else
              # should not happen, there are more
              # then one statements with the same id
              # TODO callback ERROR, null
                callback 'Multiple Statements for the same id found.'

  # Saves this statement to the database
  #
  save: (statement, callback) ->
    # Tries to store this statement and if there
    # is no id, it generates an id, otherwise
    # it checks the two statements for equality

    @validator.validateWithSchema statement, "xAPIStatement", (validatorErr) =>
      if validatorErr
        callback {code: 400, message: 'Statement is invalid.', details: validatorErr }
      else
        unless statement.id
          # No id is given, generate one
          statement.id = utils.generateUUID()
          logger.info 'generated statement id: ' + statement.id
        # Check if the given id is already in the database

        @find statement.id, (err, foundStatement) =>
          if err
            logger.error 'find returned error: ' + err
            # There is no statement with the given id,
            # the given statement will be inserted
            callback err
          else
            if foundStatement
              if @_isEqual statement, foundStatement
                # all right statement is already in the database
                callback undefined, statement
              else
                # conflict, there is a statement with the
                # same id but a different content
                callback {code: 409, message: 'Conflicting statement: Found a statement with the same id but a different content!' }
            else
              # statement does not exist yet, save it
              document =
                type: 'Statement'
                value: statement

              @dbController.db.save document, (err, res) =>
                callback err, statement

  # Checks whether two statements are equal
  # Currently by performing a deep comparison. TODO
  _isEqual: (s1, s2) ->
    _.isEqual(s1, s2)
