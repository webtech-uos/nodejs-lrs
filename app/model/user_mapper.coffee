logger = require '../logger'
_ = require 'underscore'
utils = require '../utils'

# Provides operations for all users on top
# of CouchDB.
#
module.exports = class UserMapper


  # Instanciates a new user mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (@dbController, callback) ->
    viewFindBy =
      db_id:
        map: (doc)->
          if doc.type == 'User'
            emit doc._id, doc.value
          else
            emit null, null
      id:
        map: (doc)->
          if doc.type == 'User'
            emit doc.value.id, doc.value
          else
            emit null, null
      name:
        map: (doc) ->
          if doc.type == 'User'
            emit doc.value.name, doc.value
          else
            emit null, null

    viewList =
      db_ids:
        map: (doc)->
          if doc.type == 'User'
            emit doc._id, null
          else
            emit null, null

    viewCounter =
      all_users:
        map: (doc)->
          if doc.type == 'User'
            emit null, 1
          else
            emit null, 0
        reduce: (key, values, rereduce)->
          sum values

    views = []
    views.push '_design/find_user_by' : viewFindBy
    views.push '_design/user_list' : viewList
    views.push '_design/user_counter' : viewCounter

    addUser = () =>
      users = [
        {
          username: 'bob'
          password: 'pizza'
        }
        {
          username: 'henry'
          password: 'cats'
        }
      ]

      counter = 0
      for user in users
        @save user, (err) ->
          if err
            callback err
          else
            counter++
            if counter == users.length
              callback()

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
              addUser()

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

  # Returns the user with the given id to the callback.
  #
  # @param id
  #   id of the user to look up
  #
  find: (id, callback) ->
    @dbController.db.view 'find_user_by/id', key: id, (err, docs) =>
      if err
        logger.error 'find user: ' + id
        logger.error "find: database access with view find_user_by/id failed: #{JSON.stringify err}"
        callback err, []
      else
        if docs.length == 0
          logger.info 'user does not exist: ' + id
          callback undefined
        else
          callback undefined, docs[0].value

  # Saves a user to the database
  #
  save: (user, callback) ->
    unless user.id
      # No id is given, generate one
      user.id = utils.generateUUID()

    @find user.id, (err, foundUser) =>
      if err
        logger.error 'find returned error: ' + err
        callback err
      else
        if foundUser
          callback null, foundUser
        else
          document =
            type: 'User'
            value: user

          @dbController.db.save document, (err, res) =>
            callback err, user
