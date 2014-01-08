cradle = require 'cradle'
fs = require 'fs'

# A class for initialise the database.
#
module.exports = class DBController
  # holds the dbObject
  db : null

  constructor: (@config, callback) ->
    @setup callback

  # imports some views into the database
  # @param [String] dir directory, where the views are
  _importViews = (db, dir, callback) ->
    console.log "Import views: #{dir}"
    filesFinished = 0
    do (db) ->
      fs.readdir dir, (err, files) ->
        if err
          console.error "Error while read views folder!"
          console.error err
        else
          for file in files
            do (file, db) ->
              fs.readFile "#{dir}/#{file}", (err, contents) ->
                if err
                  console.error "Error while read view file #{file}!"
                  console.error err
                else
                  view = JSON.parse contents
                  db.save view._id, view
                  console.log "imported view #{dir}/#{file}."
                  filesFinished++
                  if filesFinished == files.length
                    callback()

  # imports some test data into database
  # @param [String] dir directory, where the test data are
  _importTestData = (db, dir, callback) ->
    console.log "Import test data: #{dir}"
    filesFinished = 0
    do (db) ->
      fs.readdir dir, (err, files) ->
        if err
          console.error "Error while read test data folder!"
          console.error err
        else
          for file in files
            do (file, db) ->
              fs.readFile "#{dir}/#{file}", (err, contents) ->
                if err
                  console.error "Error while read test data file #{file}!"
                  console.error err
                else
                  testdata = JSON.parse contents
                  db.save testdata
                  console.log "imported test data #{dir}/#{file}."
                  filesFinished++
                  if filesFinished == files.length
                    callback()

  # tries to create a database
  setup : (callback) ->

    dbOptions =
      host: @config.host
      port: @config.port
      cache: true
      raw: false

    cradle.setup dbOptions
    conn = new (cradle.Connection)
    database = conn.database @config.name

    console.log "Try to connect to database server (#{dbOptions.host}:#{dbOptions.port})..."
    if @config.reset and database.exists
      console.log 'RESETTING DATABASE'
      database.destroy =>
        @_prepareDB callback, database
    else
      @_prepareDB callback, database

  _prepareDB: (callback, database, modulePath) ->
    database.exists (err, exists) =>
      if err
        console.error "Error while connect to database server!"
        console.error err
        undefined
      else if exists
        console.log "Found database '#{@config.name}' on the database server."
        @db = database
        callback()
      else
        database.create()
        @db = database
        console.log "The database '#{@config.name}' has been created."
        _importTestData database, "./app/database/testData", () =>
          _importViews database, "./app/database/views", () =>
            callback()
