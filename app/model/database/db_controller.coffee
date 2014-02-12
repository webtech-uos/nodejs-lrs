cradle = require 'cradle'
fs = require 'fs'
logger = require '../../logger'

# A class for handling all database interaction.
# Asserts that a couchDB with respective name and all required views exists.
# Based on cradle.
# Each database-controller is working on a specific database.
# There can be multiple controllers working on multiple databases at the same time.
#
module.exports = class DBController
  db : null # holds the dbObject

  # Instanciates a new database-controller based on the supplied configuration object.
  #
  constructor: (@config, callback) ->
    @setup callback

  # Tries to create a database.
  # Will return an error to callback if something bad happened.
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
      else if exists and @config.reset
        logger.warn 'RESETTING DATABASE: ' + @config.name
        database.destroy =>
          database.create =>
            @db = database
            logger.info "The database '#{@config.name}' has been created."
            callback()
      else if exists
        @db = database
        logger.info "Found database '#{@config.name}' on the database server."
        callback()
      else
        database.create =>
          @db = database
          logger.info "The database '#{@config.name}' has been created."
          callback()

  # Completely removes this database
  #
  deleteDB: (callback) ->
    @db.exists (err, exists) =>
      if err
        logger.info 'ERROR DELETING DATABASE: ' + err
        callback err
      else if exists
        logger.info "Deleting database '#{@config.name}' on the database server."
        @db.destroy =>
          callback()
