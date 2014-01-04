config = require('../config.coffee').database
dbController = require '../database/dbcontroller.coffee'

# Provides operations for all statements on top
# of couchDB.
#
module.exports = class Statement
  # returns all stored statements
  #
  @all: (callback) ->
    dbController.db
    callback []

  # returns the statement with the given id
  #
  @find: (id, callback) ->
    dbController.db
    callback new Statement

  # An object containing the json document
  # for this statement.
  map: {}

  # Creates a new statement
  #
  constructor: (data) ->

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
