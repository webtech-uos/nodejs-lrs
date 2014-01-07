config = require('../config.coffee').database
dbController = require '../database/dbcontroller.coffee'

# Provides operations for all statements on top
# of couchDB.
#
module.exports = class Statement

  # returns all stored statements
  #
  @all: (callback) ->
    dbController.db.view 'find_by/id', (err, docs) =>
      if err
        console.error "database access failed"
        console.error err
        callback err, []
      else
        statements = []
        for doc in docs
          statement = new (Statement)(doc.value)
          statements.push statement

        callback undefined, statements

  # returns the statement with the given id
  #
  @find: (id, callback) ->
    dbController.db.view 'find_by/id', key: id, (err, docs) =>
      if err
        console.error "database access failed"
        console.error err
        callback err, []
      else
        switch docs.length
          when 0
            # there is no statement with the given id
            # TODO callback ERROR, null
            null
          when 1
            # all right, one statement found
            doc = docs[0]
            statement = new (Statement)(doc.value)
            callback undefined, statement
          else
            # should not happen, there are more
            # then one statements with the same id
            # TODO callback ERROR, null
            null

  # An object containing the json document
  # for this statement.
  map: {}

  # Creates a new statement
  #
  constructor: (data) ->
    @map = data
  # Saves this statement to the database
  #
  save: (callback) ->
    # Tries to store this statement and if there
    # is no id, it generates an id, otherwise
    # ist check the two statements for equality
    if @map.id
    # if the id is already defined,
    # check if the given id is already in the database
      find @map.id, (err, statement) =>
        if err
          # there is no statement with the given id
          # the given statement will be inserted
          dbController.db.save @map, (err, res) =>
            if err
              # TODO callback ERROR, null
              null
            else
              callback undefined, this
        else
          if isEqual statement, this
            # all right statement is already in the database
            callback undefined, statement
          else
            # conflict, there is a statement with the
            # same id but a different content
            # TODO callback ERROR, null
            null
    else
      # No id is given, generate one
      @map.id = uuid()
      dbController.db.save @map, (err, res) =>
        if err
          # TODO callback ERROR, null
          null
        else
          callback undefined, this

  # Reload this statement from the database
  #
  fetch: (callback) ->
    find @map.id, (err, statement) =>
      if err
        # TODO callback ERROR, null
        null
      else
        @map = statement.map
        callback undefined, this

  @isEqual: (s1, s2) ->
    # TODO agents equality etc.
    _.isEqual(s1, s2)


  # RFC4122 A Universally Unique IDentifier (UUID) URN Namespace
  # Generates a UUID from the current date and a random number.
  uuid = ->
    d = (new (Data)()).getTime()
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = (d + Math.random()*16)%16 | 0
    d = Math.floor(d/16)
    d = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)




