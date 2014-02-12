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
  getAll: (options, callback) ->
    #TODO
    #
    #
    filter = {}

    limit = options.limit ? 0
    # if limit is set to 0 use the server maximum
    limit = 1000 if limit == 0
    # if skip was defined start at skip+1, else start at the beginning
    skip = options.skip ? 0
    newSkip = 0

    ascending = options.ascending ? false

    @views.count (err, count) =>
      scount = 0
      if count.length == 0
        #there are no statements in the db
        callback undefined, []
        return
      else
        scount = count[0]

      if skip > scount
        err = new Error 'More statements requested as there are! Illegal skip parameter!'
        err.httpCode = 400
        callback err
      else

        if skip + limit < scount
          # TODO generate URI for more statements
          newSkip = skip + limit
        filter.options =
          descending : not ascending
          skip : skip
          limit : limit

        filter.keys = []
        filter.keyNames = []

        if options.since
          keys.push options.since
          keyNames.push "since"

        if options.untill
          keys.push options.untill
          keyNames.push "untill"

        @views.find filter, (err, docs) =>
          if err
            logger.error "getALL: database access failed: #{JSON.stringify err}"
            callback err, []
          else
            statements = []
            for doc in docs
              statements.push doc.value

            options.skip = newSkip
            callback undefined, statements, options

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
