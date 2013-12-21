config = require '../../config.coffee'
cradle = require 'cradle'
fs = require 'fs'

# A class for initialise the database.
# Only run me once.
#
class InitialiseDataBase

  # Must only be runned once while app installing.
  # Create and fill the database if not exists.
  #
  constructor: ->
    @_createDataBase()

  # Used to create a database, upload views and fill the database with some sample data.
  # Views contained in `app/db-init/views`.
  # Sample data contained in `app/db-init/exampleData.json`. 
  #
  # @private
  #
  _createDataBase: ->
    dbHost = config.dbConfig.dbHost
    dbPort = config.dbConfig.dbPort
    dbName = config.dbConfig.dbName
    
    conn = new (cradle.Connection) dbHost, 5984, 
                                                cache: true 
                                                raw: false
    database = conn.database dbName

    console.log "Try to connect to database server (#{dbHost}:#{dbPort}) and create database '#{dbName}'..."

    database.exists (error, exists) ->
      if error
        console.error "Error while connect to database server!"
        console.error error

      else if exists
        console.error "Database '#{dbName}' already exists! Views and data will not be imported!"
      else
        database.create()
        fs.readFile 'data/example_data.json', (err, contents) ->
          if err
            console.error "Error while read sample data file!"
            console.error err
            database.destroy()
          else
            database.save JSON.parse contents
            
        #TODO import views
        #TODO import views
        console.log "done."
        
              
new InitialiseDataBase()
module.import = InitialiseDataBase