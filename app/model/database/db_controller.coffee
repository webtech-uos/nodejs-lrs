cradle = require 'cradle'
fs = require 'fs'
logger = require '../../logger'

# A class for handling all database interaction. 
# Asserts that a couchDB with respective name and all required views exists.
# Based on cradle.
# Each database-controller is working on a specific databasse.
# There can be multiple controllers working on multiple databases at the same time.
#
module.exports = class DBController
  db : null # holds the dbObject
  
  # Instanciates a new database-controller based on the supplied configuration object.
  #
  constructor: (@config, callback) ->
    @setup callback

  # imports some views into the database
  #
  # @param [String] dir
  #   location of the views (relative to working directory)
  _importViews = (db, dir, callback) ->
    logger.info "Importing views: #{dir}"
    filesFinished = 0
    do (db) ->
      fs.readdir dir, (err, files) ->
        if err
          logger.error "Error while readinging views folder: " + err
        else
          for file in files
            do (file, db) ->
              # FIXME: Use CoffeeScript for views
              #        include views by require instead of readFile
              fs.readFile "#{dir}/#{file}", (err, contents) ->
                if err
                  logger.error "Error while readinging view file #{file}: " + err
                else
                  view = JSON.parse contents
                  db.save view._id, view, (err) ->
                    logger.erro "unable to import view #{dir}/#{file}" if err
                    logger.info "imported view #{dir}/#{file}" unless err
                    filesFinished++
                    if filesFinished == files.length
                      callback err

  # Tries to create a database.
  # Will return an error to callback if something bad happened.
  #
  setup : (callback) ->
    dbOptions =
      host: @config.host
      port: @config.port
      cache: true
      raw: false

    cradle.setup dbOptions
    conn = new (cradle.Connection)
    database = conn.database @config.name

    logger.info "Trying to connect to database server (#{dbOptions.host}:#{dbOptions.port})..."
    database.exists (err, exists) =>
      if err
        logger.error 'ERROR UPON CONNECTING TO DATABASE: ' + err
        callback err
      else
        if exists and @config.reset
          logger.warn 'RESETTING DATABASE: ' + @config.name
          database.destroy =>
            @_prepareDB database, callback
        else
          @_prepareDB database, callback

  _prepareDB: (database, callback) ->
    database.exists (err, exists) =>
      if err
        logger.error "Error while connecting to database server: " + err
        callback err
        undefined
      else if exists
        logger.info "Found database '#{@config.name}' on the database server."
        @db = database
        callback()
      else
        database.create()
        @db = database
        logger.info "The database '#{@config.name}' has been created."
        _importViews database, "./app/model/database/views", (err) =>
          callback err
 
  deleteDB: (callback) -> 
    @db.exists (err, exists) =>
      if err
        logger.info 'ERROR DELETING DATABASE: ' + err        
        callback err
      else if exists
        logger.info "Deleting database '#{@config.name}' on the database server."
        @db.destroy =>
          callback()
        
        
        
    
    