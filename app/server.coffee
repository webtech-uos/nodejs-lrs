restify = require 'restify'
config = require './config'
routes = require './routes'
dbController = require './database/dbcontroller.coffee'

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
  constructor: (port = config.server.port) ->
    console.log "Let the magic happen."
    srvOptions =
      name: config.server.name
      version: config.server.version # A default version set for all routes

    # init database
    dbController.setup () =>
      @restServer = restify.createServer(srvOptions)
      @restServer.use restify.bodyParser()
      @_registerRoutes()
      if port
        @restServer.listen port, () =>
          console.log '%s is listening at %s', @restServer.name, @restServer.url

  # Used to register all routes contained in the file `routes.coffee`.
  #
  # @private
  #
  _registerRoutes: ->
    for url, route of routes
      for method, callback of route
        [controllerName, methodName] = callback.split '#'
        controller = new (require "./controllers/#{controllerName}")
        @restServer[method] url, do (controller, methodName) ->
          (params...) -> controller[methodName].apply(controller, params)

  # For getting the required server object when running supertest.
  #
  getRestifyServer: ->
    @restServer
