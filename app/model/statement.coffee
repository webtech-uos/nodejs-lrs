# Provides operations for all statements on top
# of couchDB.
#
# TODO: I am just a interface mockup,
#       complete my methods, 
#       use a real database.
#
module.exports = class Statement
    
  # returns all stored statements
  #
  @all: (callback) ->
    callback []

  # returns the statement with the given id
  #
  @find: (id, callback) ->
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
    callback()
    
  # Reload this statement from the database
  #
  fetch: (callback) ->
    callback()
