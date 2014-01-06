config = require('../config.coffee').database
dbController = require '../database/dbcontroller.coffee'

# Provides operations for all statements on top
# of couchDB.
#
module.exports = class Statement
  # returns all stored statements
  #
  @all: (callback) ->
    dbController.db.view 'find_by/uuid', (err, docs) =>
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
    dbController.db.view 'find_by/uuid', key: id, (err, docs) =>
      if err
        console.error "database access failed"
        console.error err
        callback err, []
      else
        if docs
          console.log docs
          doc = docs[0]
          statement = new (Statement)(doc.value)
          callback undefined, statement
        else
          #callback FEHLER, null

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
    dbController.db
    callback()

  # Reload this statement from the database
  #
  fetch: (callback) ->
    dbController.db
    callback()
