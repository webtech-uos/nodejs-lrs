restify = require 'restify'
config = require './config'
routes = require './routes'
DBController = require './database/dbcontroller.coffee'

# Main class for launching the server.
# Only instanciate me once.
#
# TODO: Instanciate database
#
module.exports = class Server

  # Should only be called once.
  # Launches the learning record store.
  #
  # @param port
  #   number if server should listen on the supplied port
  #   false if server should not listen at all (for testing purposes)
  constructor: (config, callback = ->) ->
    console.log "Let the magic happen."
    srvOptions =
      name: config.server.name
      version: config.server.version # A default version set for all routes

    @restServer = restify.createServer(srvOptions)
    @restServer.use restify.bodyParser()
    @dbController = new DBController config.database, =>
      # init database
      if config.server.port
        @restServer.listen config.server.port, =>
          console.log '%s is listening at %s', @restServer.name, @restServer.url
          callback @
      else
        callback @
        
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
        @restServer[method] url, do (controller, methodName) ->
          (params...) -> controller[methodName].apply(controller, params)

  # For getting the required server object when running supertest.
  #
  getRestifyServer: ->
    @restServer
