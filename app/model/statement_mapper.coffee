Validator = require '../validator/validator'
logger = require '../logger'
_ = require 'underscore'
utils = require '../utils'
BaseMapper = require './base_mapper'

# Provides operations for all statements on top
# of couchDB.
#
module.exports = class StatementMapper extends BaseMapper

  @TYPE = 'statement'

  @VIEWS =
    find:
      map: (doc) ->
        if doc.type == 'statement'
          emit doc.value.id, doc.value
    list_ids:
      map: (doc) ->
        if doc.type == 'statement'
          emit doc.value.id, null
        else
          emit null, null
    count:
      map: (doc) ->
        if doc.type == 'statement'
          emit null, 1
        else
          emit null, 0
      reduce: (key, values, rereduce) ->
        sum values
    find_by_agent:
      map: (doc) ->
        if doc.type == 'statement'
          emit doc.value.actor.mbox, doc.value
        else
          emit null, null
          
  # Instanciates a new statement mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: ->
    super
    @validator = new Validator 'app/validator/schemas/'

  # Returns all stored statements to the callback.
  #
  # TODO: one should be able to specify the maximum number of returned statements
  #
  getAll: (callback) ->
    startIndex = null
    maxNumberStatements = 100
    numberRequested = maxNumberStatements

    @views.count (err, count) =>
      if err
        logger.error "getALL: database access with view count/all_statements failed: #{JSON.stringify err}"
        callback err, []
      else if count.length > 0 # TODO
        scount = count[0].value
        if scount > numberRequested
          @views.list_ids descending: true, (err,  ids) =>
            if err
              logger.error "getALL: database access with list/statement_ids failed: #{JSON.stringify err}"
              callback err, []
            else
              startIndex = 0 unless startIndex

              if startIndex > scount
                err = new Error 'More statements requested as there are'
                err.httpCode = 400
                callback err
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

                @views.find filterRange, (err, docs) =>
                  if err
                    logger.error "getALL: database access with view find_statement_by/db_id failed: #{JSON.stringify err}"
                    callback err, []
                  else
                    statements = []
                    for doc in docs
                      statements.push doc.value

                    callback undefined, statements

        else
          @views.find (err, docs) =>
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
        err = new Error 'Invalid UUID supplied!'
        err.httpCode = 400
        callback err
      else
        @views.find key: id, (err, docs) =>
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
  # Tries to store this statement and if there
  # is no id, it generates an id, otherwise
  # it checks the two statements for equality
  #
  save: (statement, callback) ->
    
    @validator.validateWithSchema statement, "xAPIStatement", (validatorErr) =>
      if validatorErr
        err = new Error "Statement is invalid: #{validatorErr}"
        err.httpCode = 400
        callback err
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
              if _.isEqual statement, foundStatement
                # all right statement is already in the database
                callback undefined, statement
              else
                # conflict, there is a statement with the
                # same id but a different content
                err = new Error 'Conflicting statement: Found a statement with the same id but a different content!'
                err.httpCode = 409
                callback err
            else
              super statement, (err, res) =>
                callback err, statement

  findByAgent: (agent, callback) ->
    @views.find_by_agent key: agent, (err, docs) =>
      if err
        logger.info 'findByAgent failed: ' + err
        callback err
      else
        statements = []
        for doc in docs
          statements.push doc.value
          
        callback undefined, statements