express = require 'express'
config = require './config'
routes = require './routes'
DBController = require './model/database/db_controller.coffee'
logger = require './logger'

# Main class for launching the server.
# Only instanciate me once.
#
module.exports = class Server

  # Should only be called once.
  # Launches the learning record store.
  #
  # @param config
  #   the configuration object, for details
  #   take a look at `config.coffee`
  #
  # @param callback
  #   Will be called as soon as the server is started
  #   or an error occured (first parameter).
  #   If no error occured one can assume a valid database
  #   connection and listening HTTP server.
  #
  constructor: (config, callback = ->) ->
    logger.info "Let the magic happen."

    @express = express()
    @express.use express.logger stream:
      write: (message) -> logger.info message
    @express.use express.json()
    
    @dbController = new DBController config.database, (err) =>
      if err
        callback err
      else
        if config.server.port
          @express.listen config.server.port, (err) =>
            logger.info 'server listening'
            callback err, @
        else
          callback undefined, @
    @_registerRoutes()

  # Used to register all routes contained in the file `routes.coffee`.
  #
  # @private
  #
  _registerRoutes: ->
    controllers = {}
    for url, route of routes
      for method, callback of route
        [controllerName, methodName] = callback.split '#'
        controller = controllers[controllerName] ?= new (require "./controllers/#{controllerName}") @dbController
        logger.info "registering route '#{method} #{url}'"
        if url[0] isnt '/'
          url = '/' + url
        @express[method] url, do (controller, methodName) ->
          (params...) -> controller[methodName].apply(controller, params)

  # For getting the required server object when running supertest.
  #
  getRestServer: ->
    @express

  # For getting the required database controller when running supertest.
  #
  getDBController: ->
    @dbController
